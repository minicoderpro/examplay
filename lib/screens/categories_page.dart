import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category, size: 50, color: Colors.blue),
          SizedBox(height: 20),
          Text("All Categories", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Text("Explore courses by category", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}