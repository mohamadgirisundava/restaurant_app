import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/static/navigation_route.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/style/colors/main_color.dart';
import '../models/restaurant.dart';
import '../viewmodels/restaurant_bookmark_provider.dart';

class RestaurantItemWidget extends StatelessWidget {
  final Restaurant? data;

  const RestaurantItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          NavigationRoute.detailRoute.name,
          arguments: data as Restaurant,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? MainColor.grey900.color
                  : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border:
              isDarkMode
                  ? Border.all(color: Colors.white12, width: 1)
                  : Border.all(color: Theme.of(context).cardColor, width: 1),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withAlpha(102)
                      : Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'restaurant_image_${data?.pictureId ?? ''}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/medium/${data?.pictureId ?? ''}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, value, loadingProgress) {
                      if (loadingProgress == null) return value;

                      return Shimmer.fromColors(
                        baseColor: MainColor.grey300.color,
                        highlightColor: MainColor.grey200.color,
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: MainColor.grey300.color,
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      data?.name ?? '-',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      minFontSize: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        AutoSizeText(
                          data?.rating.toString() ?? '-',
                          style: TextStyle(
                            color: MainColor.amber700.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          minFontSize: 8,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AutoSizeText(
                      data?.description ?? '-',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      minFontSize: 12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        AutoSizeText(
                          data?.city ?? '-',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          minFontSize: 12,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Consumer<RestaurantBookmarkProvider>(
                builder: (context, bookmarkProvider, _) {
                  final isBookmarked = bookmarkProvider.isBookmarked(data!.id);

                  return IconButton(
                    onPressed: () => bookmarkProvider.toggleBookmark(data!),
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color:
                          isBookmarked
                              ? MainColor.amber700.color
                              : MainColor.grey600.color,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
