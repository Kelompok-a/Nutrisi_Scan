import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../models/produk.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';

class NutritionCalculatorPage extends StatefulWidget {
  const NutritionCalculatorPage({super.key});

  @override
  State<NutritionCalculatorPage> createState() => _NutritionCalculatorPageState();
}

class _NutritionCalculatorPageState extends State<NutritionCalculatorPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Produk> _selectedProducts = [];
  List<Produk> _searchResults = [];
  bool _isSearching = false;
  
  // Thresholds (Daily Value approximations)
  final double _maxCalories = 2150;
  final double _maxSugar = 50; // grams
  final double _maxFat = 67; // grams
  final double _maxCarbs = 275; // grams

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Use ProductProvider to search
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.searchProducts(query);
    
    if (mounted) {
      setState(() {
        _searchResults = productProvider.products; // Assuming provider updates its list
        _isSearching = false;
      });
    }
  }

  void _addProduct(Produk product) {
    setState(() {
      if (!_selectedProducts.any((p) => p.barcodeId == product.barcodeId)) {
        _selectedProducts.add(product);
      }
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _removeProduct(Produk product) {
    setState(() {
      _selectedProducts.removeWhere((p) => p.barcodeId == product.barcodeId);
    });
  }

  double _calculateTotal(double Function(Produk) selector) {
    return _selectedProducts.fold(0.0, (sum, item) => sum + selector(item));
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = _calculateTotal((p) => p.totalCalories);
    final totalSugar = _calculateTotal((p) => p.totalSugar);
    final totalFat = _calculateTotal((p) => p.totalFat);
    final totalCarbs = _calculateTotal((p) => p.totalCarbohydrates);

    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: const Text('Kalkulator Nutrisi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.kSurfaceColor,
        elevation: 0,
        foregroundColor: AppTheme.kTextColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk untuk ditambahkan...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchProducts('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    // Debounce could be added here
                    if (value.length > 2) {
                      _searchProducts(value);
                    } else if (value.isEmpty) {
                      _searchProducts('');
                    }
                  },
                ),
              ),
              
              // Search Results List (Overlay or below)
              if (_searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final product = _searchResults[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageProductLink ?? '',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(product.namaProduk, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${product.totalCalories.toStringAsFixed(0)} kcal'),
                        trailing: const Icon(Icons.add_circle_outline, color: AppTheme.kPrimaryColor),
                        onTap: () => _addProduct(product),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),

              // Selected Products List
              if (_selectedProducts.isNotEmpty) ...[
                const Text(
                  'Produk Dipilih:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final product = _selectedProducts[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.kPrimaryColor.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageProductLink ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(product.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${product.totalCalories.toStringAsFixed(0)} kcal | Gula: ${product.totalSugar}g',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => _removeProduct(product),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ] else 
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Belum ada produk dipilih', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),

              // Results Section
              if (_selectedProducts.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Total Nutrisi:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // Gauge for Calories
                _buildGaugeCard(
                  title: 'Total Kalori',
                  value: totalCalories,
                  max: _maxCalories,
                  unit: 'kcal',
                ),
                const SizedBox(height: 16),
                
                // Gauge for Sugar
                _buildGaugeCard(
                  title: 'Total Gula',
                  value: totalSugar,
                  max: _maxSugar,
                  unit: 'g',
                ),
                 const SizedBox(height: 16),

                 // Gauge for Fat
                _buildGaugeCard(
                  title: 'Total Lemak',
                  value: totalFat,
                  max: _maxFat,
                  unit: 'g',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGaugeCard({
    required String title,
    required double value,
    required double max,
    required String unit,
  }) {
    // Determine status
    String status;
    Color statusColor;
    double percentage = value / max;

    if (percentage < 0.5) {
      status = 'Aman';
      statusColor = Colors.green;
    } else if (percentage < 0.8) {
      status = 'Normal';
      statusColor = Colors.blue;
    } else if (percentage <= 1.0) {
      status = 'Tinggi';
      statusColor = Colors.orange;
    } else {
      status = 'Berlebihan';
      statusColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            width: 200,
            child: CustomPaint(
              painter: GaugePainter(percentage: percentage > 1.2 ? 1.2 : percentage), // Cap visual at 120%
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${value.toStringAsFixed(1)} / ${max.toStringAsFixed(0)} $unit',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percentage;

  GaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = size.width / 2.2;
    final strokeWidth = 20.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background arc
    paint.color = Colors.grey.shade200;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Draw colored segments (Gradient look)
    // 0 - 0.5 (Green)
    // 0.5 - 0.8 (Blue)
    // 0.8 - 1.0 (Orange)
    // > 1.0 (Red)
    
    // We draw the active arc based on percentage
    // Map percentage 0.0 -> 1.0 to angle PI -> 2*PI
    
    double sweepAngle = math.pi * percentage;
    if (sweepAngle > math.pi) sweepAngle = math.pi; // Cap at full semi-circle

    // Gradient for the active part
    final gradient = SweepGradient(
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.orange,
        Colors.red,
      ],
      stops: const [0.0, 0.5, 0.8, 1.0],
      transform: GradientRotation(math.pi/2), // Rotate to match arc start
    );
    
    // Actually, simple colored segments might be better for "meter" look
    // Let's draw segments
    
    // Segment 1: Low (Green)
    _drawSegment(canvas, center, radius, math.pi, math.pi * 0.5, Colors.green);
    // Segment 2: Normal (Blue)
    _drawSegment(canvas, center, radius, math.pi + math.pi * 0.5, math.pi * 0.3, Colors.blue);
    // Segment 3: High (Orange)
    _drawSegment(canvas, center, radius, math.pi + math.pi * 0.8, math.pi * 0.2, Colors.orange);
    // Segment 4: Excessive (Red) - technically this would be beyond the main arc, 
    // but let's just color the whole thing based on value for the "needle" context.
    
    // Re-draw simple gradient arc for the "track"
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Colors.green, Colors.blue, Colors.orange, Colors.red],
        stops: [0.0, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      
    // Rotate canvas to align gradient
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi);
    canvas.translate(-center.dx, -center.dy);
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi,
      false,
      trackPaint,
    );
    canvas.restore();

    // Draw Needle
    final needleLength = radius - 10;
    final needleAngle = math.pi + (math.pi * percentage).clamp(0.0, math.pi);
    
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);
    
    // Draw Pivot
    canvas.drawCircle(center, 8, Paint()..color = Colors.black87);
  }

  void _drawSegment(Canvas canvas, Offset center, double radius, double startAngle, double sweepAngle, Color color) {
     final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..color = color;
      
      // This was for the segmented look, but gradient is nicer. Kept for reference.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
