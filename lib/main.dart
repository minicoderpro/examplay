import 'package:flutter/material.dart';
import 'package:examplay/screens/homepage.dart';

void main() {
  runApp(const ExamPlayApp());
}

class ExamPlayApp extends StatelessWidget {
  const ExamPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examplay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F4F4),
      ),
      home: const HomePage(),
    );
  }
}