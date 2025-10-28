
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ResultPage extends StatelessWidget {
  final int sugarLevel;

  ResultPage({required this.sugarLevel});

  String getResult() {
    if (sugarLevel < 70) {
      return 'Rendah';
    } else if (sugarLevel >= 70 && sugarLevel <= 100) {
      return 'Normal';
    } else {
      return 'Tinggi';
    }
  }

  String getInterpretation() {
    if (sugarLevel < 70) {
      return 'Kadar gula Anda rendah. Sebaiknya konsumsi makanan manis.';
    } else if (sugarLevel >= 70 && sugarLevel <= 100) {
      return 'Kadar gula Anda normal. Pertahankan pola makan sehat.';
    } else {
      return 'Kadar gula Anda tinggi. Batasi konsumsi gula dan karbohidrat.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pengecekan'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Hasil Anda',
                style: kTitleTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: kActiveCardColour,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getResult(),
                    style: kResultTextStyle,
                  ),
                  Text(
                    sugarLevel.toString(),
                    style: kBMITextStyle,
                  ),
                  Text(
                    getInterpretation(),
                    textAlign: TextAlign.center,
                    style: kBodyTextStyle,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Kembali'),
          )
        ],
      ),
    );
  }
}
