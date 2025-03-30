import 'package:flutter/material.dart';

import '../utils/responsive_helper.dart';

class SearchBarWithToggle extends StatelessWidget {
  final TextEditingController controller;
  final bool isGridView;
  final ValueChanged<String> onChanged;
  final VoidCallback onTogglePressed;

  const SearchBarWithToggle({
    super.key,
    required this.controller,
    required this.isGridView,
    required this.onChanged,
    required this.onTogglePressed,
  });

  // Update search_bar.dart
  @override
  Widget build(BuildContext context) {
    return Padding(
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 0,
                    tablet: 4,
                    desktop: 8,
                  ),
                  horizontal: ResponsiveHelper.responsiveValue(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: ResponsiveHelper.responsiveValue(
            context,
            mobile: 8,
            tablet: 12,
            desktop: 16,
          )),
          IconButton(
            icon: Icon(
              isGridView ? Icons.list : Icons.grid_view,
              size: ResponsiveHelper.responsiveValue(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),
            onPressed: onTogglePressed,
          ),
        ],
      ),
    );
  }
}