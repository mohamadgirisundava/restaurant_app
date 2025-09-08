import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/feature/home/viewmodels/home_provider.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_bookmark_provider.dart';
import 'package:restaurant_app/feature/restaurant/widgets/restaurant_item_widget.dart';

class RestaurantBookmarkScreen extends StatelessWidget {
  const RestaurantBookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'RestoFind 🍽️',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () => themeProvider.toggleTheme(),
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                tooltip:
                    isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              ),
            ],
          ),
          body: Consumer<RestaurantBookmarkProvider>(
            builder: (context, value, child) {
              final bookmarkList = value.bookmarkList;
              if (bookmarkList.isNotEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverList.separated(
                      itemCount: bookmarkList.length,
                      itemBuilder: (context, index) {
                        final restaurant = bookmarkList[index];

                        return RestaurantItemWidget(data: restaurant);
                      },
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 10),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                );
              } else {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "You haven't bookmarked any restaurants yet.\nStart adding your favorite places.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        minFontSize: 8,
                        maxLines: 5,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
