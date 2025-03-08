// main.dart
import 'package:flutter/material.dart';
import 'ecg_chart.dart';

void main() {
  runApp(ECGApp());
}

class ECGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical ECG Monitor',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.lightGreenAccent,
        textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      home: ECGMonitorScreen(),
    );
  }
}