import 'package:flutter/material.dart';
import 'package:examplay/screens/homepage.dart';
import 'package:examplay/utils/responsive_helper.dart';

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
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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