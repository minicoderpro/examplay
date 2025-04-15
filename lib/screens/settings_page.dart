import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 50, color: Colors.blue),
          SizedBox(height: 20),
          Text("Settings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Text("Customize your app experience", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}