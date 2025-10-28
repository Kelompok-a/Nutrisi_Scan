
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'SugarChecker',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),
            Text(
              'SugarChecker adalah aplikasi sederhana untuk membantu Anda memantau kadar gula darah. Aplikasi ini menyediakan alat pengecekan cepat dan informasi penting seputar kesehatan gula darah. Tujuan kami adalah untuk meningkatkan kesadaran akan pentingnya menjaga kadar gula darah yang sehat.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 40),
            Text(
              '© 2024 SugarChecker. All rights reserved.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
