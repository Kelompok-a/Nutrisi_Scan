import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../models/produk.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/hoverable_card.dart';
import '../services/api_service.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final theme = Theme.of(context);
    final totalCalories = _calculateTotal((p) => p.totalCalories);
    final totalSugar = _calculateTotal((p) => p.totalSugar);
    final totalFat = _calculateTotal((p) => p.totalFat);
    final totalCarbs = _calculateTotal((p) => p.totalCarbohydrates);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Kalkulator Nutrisi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        foregroundColor: theme.appBarTheme.foregroundColor,
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
                  color: theme.cardColor,
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
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Cari produk untuk ditambahkan...',
                    hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
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
              
              // Search Results Grid
              if (_searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: 400, // Fixed height for grid area
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final product = _searchResults[index];
                      return _buildProductCard(product, theme);
                    },
                  ),
                ),

              const SizedBox(height: 24),

              // Selected Products List
              if (_selectedProducts.isNotEmpty) ...[
                Text(
                  'Produk Dipilih:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
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
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageProductLink != null && product.imageProductLink!.isNotEmpty
                                ? '${ApiService.baseUrl}/api/image-proxy?url=${Uri.encodeComponent(product.imageProductLink!)}'
                                : '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Icon(Icons.image_not_supported, color: theme.iconTheme.color),
                          ),
                        ),
                        title: Text(product.namaProduk, style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
                        subtitle: Text(
                          '${product.totalCalories.toStringAsFixed(0)} kcal | Gula: ${product.totalSugar}g\nBarcode: ${product.barcodeId}',
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 12),
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
              ] else if (_searchResults.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 64, color: theme.disabledColor),
                        const SizedBox(height: 16),
                        Text('Belum ada produk dipilih', style: TextStyle(color: theme.disabledColor)),
                      ],
                    ),
                  ),
                ),

              // Results Section
              if (_selectedProducts.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Total Nutrisi:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                ),
                const SizedBox(height: 24),
                
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      // Horizontal Layout (Landscape/Desktop)
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildGaugeCard(
                              title: 'Total Kalori',
                              value: totalCalories,
                              max: _maxCalories,
                              unit: 'kcal',
                              theme: theme,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGaugeCard(
                              title: 'Total Gula',
                              value: totalSugar,
                              max: _maxSugar,
                              unit: 'g',
                              theme: theme,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGaugeCard(
                              title: 'Total Lemak',
                              value: totalFat,
                              max: _maxFat,
                              unit: 'g',
                              theme: theme,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Vertical Layout (Portrait/Mobile)
                      return Column(
                        children: [
                          _buildGaugeCard(
                            title: 'Total Kalori',
                            value: totalCalories,
                            max: _maxCalories,
                            unit: 'kcal',
                            theme: theme,
                          ),
                          const SizedBox(height: 16),
                          _buildGaugeCard(
                            title: 'Total Gula',
                            value: totalSugar,
                            max: _maxSugar,
                            unit: 'g',
                            theme: theme,
                          ),
                          const SizedBox(height: 16),
                          _buildGaugeCard(
                            title: 'Total Lemak',
                            value: totalFat,
                            max: _maxFat,
                            unit: 'g',
                            theme: theme,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Produk product, ThemeData theme) {
    return HoverableCard(
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _addProduct(product),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: product.imageProductLink != null && product.imageProductLink!.isNotEmpty
                        ? Image.network(
                            '${ApiService.baseUrl}/api/image-proxy?url=${Uri.encodeComponent(product.imageProductLink!)}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: theme.primaryColor.withOpacity(0.1),
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: theme.primaryColor.withOpacity(0.5),
                                size: 40,
                              ),
                            ),
                          )
                        : Container(
                            color: theme.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.fastfood_rounded,
                              color: theme.primaryColor,
                              size: 40,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.namaProduk,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Barcode: ${product.barcodeId}',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product.totalCalories.toStringAsFixed(0)} kcal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              Icons.add_circle,
                              color: theme.primaryColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    required ThemeData theme,
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
        color: theme.cardColor,
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
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            width: 200,
            child: CustomPaint(
              painter: GaugePainter(percentage: percentage > 1.2 ? 1.2 : percentage, theme: theme), // Cap visual at 120%
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
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 12),
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
  final ThemeData theme;

  GaugePainter({required this.percentage, required this.theme});

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
    paint.color = theme.brightness == Brightness.dark 
        ? Colors.white.withOpacity(0.1) 
        : Colors.grey.shade200;
        
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

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
      ..color = theme.textTheme.bodyLarge?.color ?? Colors.black87
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, needleEnd, needlePaint);
    
    // Draw Pivot
    canvas.drawCircle(center, 8, Paint()..color = theme.textTheme.bodyLarge?.color ?? Colors.black87);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
