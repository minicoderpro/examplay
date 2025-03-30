import 'package:flutter/material.dart';

import '../utils/responsive_helper.dart';

class LoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LoadMoreButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  // Update load_more_button.dart
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.responsiveValue(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
        vertical: ResponsiveHelper.responsiveValue(
          context,
          mobile: 8,
          tablet: 12,
          desktop: 16,
        ),
      ),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4289CE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.responsiveValue(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: ResponsiveHelper.responsiveValue(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 28,
          ),
          height: ResponsiveHelper.responsiveValue(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 28,
          ),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          'আরও দেখুন',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveValue(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}