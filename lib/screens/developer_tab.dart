import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/responsive_helper.dart';

class DeveloperTab extends StatelessWidget {
  const DeveloperTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          ResponsiveHelper.responsiveValue(
            context,
            mobile: 16.0,
            tablet: 24.0,
            desktop: 32.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ResponsiveHelper.responsiveValue(
              context,
              mobile: 20,
              tablet: 30,
              desktop: 40,
            )),
            CircleAvatar(
              radius: ResponsiveHelper.responsiveValue(
                context,
                mobile: 60,
                tablet: 80,
                desktop: 100,
              ),
              backgroundImage: const NetworkImage(
                'https://via.placeholder.com/150',
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveValue(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            )),
            Text(
              'Huzaifa Coder',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveValue(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            )),
            Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveValue(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                color: const Color(0xFF666666),
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