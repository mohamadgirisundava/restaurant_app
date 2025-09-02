import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/feature/home/views/home_screen.dart';
import 'package:restaurant_app/feature/main/viewmodels/index_nav_provider.dart';
import 'package:restaurant_app/feature/restaurant/views/restaurant_bookmark_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            0 => const HomeScreen(),
            _ => const RestaurantBookmarkScreen(),
          };
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          context.read<IndexNavProvider>().setIndexBottomNavBar = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: "Bookmarks",
            tooltip: "Bookmarks",
          ),
        ],
      ),
    );
  }
}
