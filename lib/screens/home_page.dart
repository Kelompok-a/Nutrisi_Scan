
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sugarLevel = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sugar Checker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Geser untuk mengatur kadar gula:',
            style: kLabelTextStyle,
          ),
          Slider(
            value: sugarLevel.toDouble(),
            min: 50,
            max: 200,
            onChanged: (double newValue) {
              setState(() {
                sugarLevel = newValue.round();
              });
            },
          ),
          Text(
            sugarLevel.toString(),
            style: kNumberTextStyle,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(sugarLevel: sugarLevel),
                ),
              );
            },
            child: Text('Periksa'),
          ),
        ],
      ),
    );
  }
}
