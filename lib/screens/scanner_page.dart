import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/search_history_provider.dart';
import '../models/produk.dart';
import 'product_detail_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  
  bool _isProcessing = false;
  bool _flashOn = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
    });
    _controller.toggleTorch();
  }

  Future<void> _processBarcode(String barcode) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      // Show loading
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Fetch product from API
      final produk = await _apiService.getProdukByBarcode(barcode);
      
      // Save to history as "scan"
      if (mounted) {
        final historyProvider = Provider.of<SearchHistoryProvider>(context, listen: false);
        historyProvider.addScanResult(produk.namaProduk);
      }

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to product detail
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(produk: produk),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Produk Tidak Ditemukan'),
            content: Text(
              'Barcode: $barcode\n\n'
              'Produk tidak ditemukan di database. '
              'Coba scan produk lain atau cari manual.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isProcessing = false;
                  });
                },
                child: const Text('Coba Lagi'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Back to search page
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
            tooltip: 'Flash',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !_isProcessing) {
                final barcode = barcodes.first;
                if (barcode.rawValue != null) {
                  _processBarcode(barcode.rawValue!);
                }
              }
            },
          ),
          
          // Overlay with scanning area
          CustomPaint(
            painter: ScannerOverlayPainter(),
            child: Container(),
          ),
          
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Arahkan kamera ke barcode produk',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showManualInputDialog();
                    },
                    icon: const Icon(Icons.keyboard),
                    label: const Text('Input Manual'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualInputDialog() {
    final TextEditingController barcodeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Barcode Manual'),
        content: TextField(
          controller: barcodeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Masukkan nomor barcode',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final barcode = barcodeController.text.trim();
              if (barcode.isNotEmpty) {
                Navigator.of(context).pop();
                _processBarcode(barcode);
              }
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }
}

// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanAreaSize = size.width * 0.7;
    final scanAreaLeft = (size.width - scanAreaSize) / 2;
    final scanAreaTop = (size.height - scanAreaSize) / 2;
    final scanAreaRect = Rect.fromLTWH(
      scanAreaLeft,
      scanAreaTop,
      scanAreaSize,
      scanAreaSize * 0.6,
    );

    // Draw dark overlay
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        scanAreaRect,
        const Radius.circular(12),
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw corner brackets
    final bracketPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const bracketLength = 30.0;

    // Top-left corner
    canvas.drawLine(
      Offset(scanAreaLeft, scanAreaTop + bracketLength),
      Offset(scanAreaLeft, scanAreaTop),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft, scanAreaTop),
      Offset(scanAreaLeft + bracketLength, scanAreaTop),
      bracketPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(scanAreaLeft + scanAreaSize - bracketLength, scanAreaTop),
      Offset(scanAreaLeft + scanAreaSize, scanAreaTop),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft + scanAreaSize, scanAreaTop),
      Offset(scanAreaLeft + scanAreaSize, scanAreaTop + bracketLength),
      bracketPaint,
    );

    // Bottom-left corner
    final scanAreaBottom = scanAreaTop + scanAreaSize * 0.6;
    canvas.drawLine(
      Offset(scanAreaLeft, scanAreaBottom - bracketLength),
      Offset(scanAreaLeft, scanAreaBottom),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft, scanAreaBottom),
      Offset(scanAreaLeft + bracketLength, scanAreaBottom),
      bracketPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(scanAreaLeft + scanAreaSize - bracketLength, scanAreaBottom),
      Offset(scanAreaLeft + scanAreaSize, scanAreaBottom),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft + scanAreaSize, scanAreaBottom - bracketLength),
      Offset(scanAreaLeft + scanAreaSize, scanAreaBottom),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}