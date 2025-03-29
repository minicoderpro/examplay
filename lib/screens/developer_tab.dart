import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperTab extends StatelessWidget {
  const DeveloperTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Huzaifa Coder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Contact Developer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4289CE),
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.email,
              label: 'huzaifa@example.com',
              onTap: () => _launchUrl('mailto:huzaifa@example.com'),
            ),
            _buildContactItem(
              icon: Icons.phone,
              label: '+880 1234 567890',
              onTap: () => _launchUrl('tel:+8801234567890'),
            ),
            _buildContactItem(
              icon: Icons.web,
              label: 'www.huzaifacoder.com',
              onTap: () => _launchUrl('https://www.huzaifacoder.com'),
            ),
            _buildContactItem(
              icon: Icons.facebook,
              label: 'facebook.com/huzaifacoder',
              onTap: () => _launchUrl('https://facebook.com/huzaifacoder'),
            ),
            const SizedBox(height: 24),
            const Text(
              'App Version: 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4289CE)),
      title: Text(label),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}