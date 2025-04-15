import 'package:examplay/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExamplayApp());

class ExamplayApp extends StatelessWidget {
  const ExamplayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examplay',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}