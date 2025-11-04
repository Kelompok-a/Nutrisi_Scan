
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';
import 'profile_page.dart';

const Color kPrimaryColor = Color(0xFF0056b3);
const Color kOverlayColor = Color.fromRGBO(0, 0, 0, 0.6);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  int? _sugarLevel;

  void _checkSugarLevel() {
    FocusScope.of(context).unfocus();
    if (_controller.text.isNotEmpty) {
      setState(() {
        _sugarLevel = int.tryParse(_controller.text);
      });
    }
  }

  // Helper to create a slide-in animation
  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nutriscan'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: authProvider.isLoggedIn
                ? [
                    Tooltip(
                      message: 'Profil',
                      child: IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          Navigator.of(context).push(_createSlideRoute(const ProfilePage()));
                        },
                      ),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(_createSlideRoute(const LoginPage()));
                      },
                      child: const Text('Login', style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        // Placeholder for Signup functionality
                      },
                      child: const Text('Signup', style: TextStyle(color: Colors.white)),
                    ),
                  ],
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _checkSugarLevel,
                            child: const Text('Periksa Sekarang'),
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (_sugarLevel != null)
                          ResultWidget(sugarLevel: _sugarLevel!),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
