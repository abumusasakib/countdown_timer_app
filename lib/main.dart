import 'package:flutter/material.dart';
import 'widgets/timer_widget.dart';

void main() {
  runApp(const CountdownTimerApp());
}

class CountdownTimerApp extends StatelessWidget {
  const CountdownTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Countdown Timer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TimerWidget(),
    );
  }
}
