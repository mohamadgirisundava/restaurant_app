import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController searchController;

  const SearchWidget({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search restaurants...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              searchController.text.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () {})
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {},
        onSubmitted: (value) {},
      ),
    );
  }
}
