
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// It's a good practice to define constants for colors and styles
// to ensure consistency and ease of maintenance.
const Color kPrimaryColor = Color(0xFF0056b3);
const Color kOverlayColor = Color.fromRGBO(0, 0, 0, 0.6); // 153 alpha is roughly 0.6 opacity

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  SugarLevelResult? _result;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final isInputNotEmpty = _controller.text.isNotEmpty;
      if (_isButtonEnabled != isInputNotEmpty) {
        setState(() {
          _isButtonEnabled = isInputNotEmpty;
        });
      }
      // Hide result if input is cleared
      if (!isInputNotEmpty && _result != null) {
        setState(() {
          _result = null;
        });
      }
    });
  }

  void _checkSugarLevel() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final value = int.tryParse(_controller.text);
    setState(() {
      if (value != null) {
        _result = SugarLevelResult(value: value);
      } else {
        _result = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              // Using a local asset is more reliable and performant than a network image for static assets.
              // Make sure to add the image to your pubspec.yaml assets section.
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: kOverlayColor,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Cek Kadar Gula Darah Anda',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Kadar Gula Darah (mg/dL)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled ? _checkSugarLevel : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: kPrimaryColor.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Periksa Sekarang'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_result != null) ResultWidget(result: _result!),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SugarLevelResult {
  final int value;

  SugarLevelResult({required this.value});

  String get result {
    if (value < 70) return 'Rendah';
    if (value <= 100) return 'Normal';
    return 'Tinggi';
  }

  String get interpretation {
    if (value < 70) return 'Kadar gula Anda rendah. Sebaiknya konsumsi makanan manis.';
    if (value <= 100) return 'Kadar gula Anda normal. Pertahankan pola makan sehat.';
    return 'Kadar gula Anda tinggi. Batasi konsumsi gula dan karbohidrat.';
  }

  Color get resultColor {
    if (value < 70) return Colors.orange;
    if (value <= 100) return Colors.green;
    return Colors.red;
  }
}

class ResultWidget extends StatelessWidget {
  final SugarLevelResult result;

  const ResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: result.resultColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'Hasil: ${result.result}',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '${result.value} mg/dL',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: result.resultColor),
                ),
                const SizedBox(height: 10),
                Text(
                  result.interpretation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
