
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  int? _sugarLevel;

  void _checkSugarLevel() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _sugarLevel = int.tryParse(_controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage('https://sugarchecker.id/wp-content/uploads/2023/11/dedi-sutanto-p-2-1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
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
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0056b3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _checkSugarLevel,
                        child: const Text('Periksa Sekarang'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_sugarLevel != null) ResultWidget(sugarLevel: _sugarLevel!),
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

class ResultWidget extends StatelessWidget {
  final int sugarLevel;

  const ResultWidget({super.key, required this.sugarLevel});

  String getResult() {
    if (sugarLevel < 70) return 'Rendah';
    if (sugarLevel <= 100) return 'Normal';
    return 'Tinggi';
  }

  String getInterpretation() {
    if (sugarLevel < 70) return 'Kadar gula Anda rendah. Sebaiknya konsumsi makanan manis.';
    if (sugarLevel <= 100) return 'Kadar gula Anda normal. Pertahankan pola makan sehat.';
    return 'Kadar gula Anda tinggi. Batasi konsumsi gula dan karbohidrat.';
  }

  Color getResultColor() {
    if (sugarLevel < 70) return Colors.orange;
    if (sugarLevel <= 100) return Colors.green;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final result = getResult();
    final color = getResultColor();

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
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'Hasil: $result',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '$sugarLevel mg/dL',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 10),
                Text(
                  getInterpretation(),
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
