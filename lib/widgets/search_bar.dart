import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: onTogglePressed,
          ),
        ],
      ),
    );
  }
}