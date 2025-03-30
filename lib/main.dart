import 'package:examplay/screens/homepage.dart';
import 'package:examplay/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExamPlayApp());
}

// Update main.dart
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
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: ResponsiveHelper.responsiveValue(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontSize: ResponsiveHelper.responsiveValue(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}