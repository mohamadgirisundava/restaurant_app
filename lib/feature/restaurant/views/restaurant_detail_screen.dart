// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/feature/restaurant/models/restaurant.dart';
import 'package:restaurant_app/feature/restaurant/models/restaurant_detail.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_detail_provider.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_detail_state.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_bookmark_provider.dart';
import 'package:restaurant_app/core/widgets/loading_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:restaurant_app/feature/restaurant/models/add_review_request.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/add_review_provider.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/add_review_state.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant? restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurant?.id ?? '',
      );
      context.read<AddReviewProvider>().resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, detailProvider, child) {
          final state = detailProvider.restaurantDetailState;

          if (state is RestaurantDetailLoadingState) {
            return _buildLoadingState();
          } else if (state is RestaurantDetailErrorState) {
            return _buildErrorState(state.message);
          } else if (state is RestaurantDetailSuccessState) {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(state.data),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRestaurantInfo(state.data),
                        const SizedBox(height: 20),
                        _buildDescription(state.data),
                        const SizedBox(height: 20),
                        _buildCategories(state.data),
                        const SizedBox(height: 20),
                        _buildMenuSection(state.data),
                        const SizedBox(height: 20),
                        _buildReviewsSection(state.data),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Container(color: Colors.white),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: LoadingWidget()),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.error_outline, size: 64, color: Colors.grey),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<RestaurantDetailProvider>()
                        .fetchRestaurantDetail(widget.restaurant?.id ?? '');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(RestaurantDetail restaurant) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
      actions: [
        Consumer<RestaurantBookmarkProvider>(
          builder: (context, bookmarkProvider, child) {
            final isBookmarked = bookmarkProvider.isBookmarked(restaurant.id);

            return IconButton(
              onPressed: () {
                bookmarkProvider.toggleBookmark(
                  Restaurant(
                    id: restaurant.id,
                    name: restaurant.name,
                    description: restaurant.description,
                    pictureId: restaurant.pictureId,
                    city: restaurant.city,
                    rating: restaurant.rating,
                  ),
                );
              },
              icon: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color:
                      isBookmarked
                          ? Colors.amber[700]
                          : Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'restaurant_image_${restaurant.pictureId}',
          child: Image.network(
            'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
            fit: BoxFit.cover,
            loadingBuilder: (context, child2, loadingProgress) {
              if (loadingProgress == null) return child2;
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: Container(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.restaurant,
                  size: 64,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo(RestaurantDetail restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: AutoSizeText(
                restaurant.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 8,
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 5),
            AutoSizeText(
              restaurant.rating.toString(),
              style: TextStyle(
                color: Colors.amber[700],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              minFontSize: 12,
              maxLines: 1,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on, color: Colors.redAccent, size: 18),
            const SizedBox(width: 5),
            Expanded(
              child: AutoSizeText(
                '${restaurant.address}, ${restaurant.city}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
                minFontSize: 8,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(RestaurantDetail restaurant) {
    final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'About',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 16,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        ValueListenableBuilder<bool>(
          valueListenable: isExpanded,
          builder: (context, isExpandedValue, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  restaurant.description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                  minFontSize: 12,
                  maxLines: isExpandedValue ? null : 3,
                  overflow:
                      isExpandedValue
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                ),
                GestureDetector(
                  onTap: () {
                    isExpanded.value = !isExpanded.value;
                  },
                  child: AutoSizeText(
                    isExpandedValue ? 'See less' : 'See more',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategories(RestaurantDetail restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Categories',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 16,
          maxLines: 1,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              restaurant.categories.map((category) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(77),
                    ),
                  ),
                  child: AutoSizeText(
                    category.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    minFontSize: 10,
                    maxLines: 1,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildMenuSection(RestaurantDetail restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Menu',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 16,
          maxLines: 1,
        ),
        const SizedBox(height: 16),
        _buildMenuCategory('Foods', restaurant.menus.foods, Icons.restaurant),
        const SizedBox(height: 24),
        _buildMenuCategory(
          'Drinks',
          restaurant.menus.drinks,
          Icons.local_drink,
        ),
      ],
    );
  }

  Widget _buildMenuCategory(String title, List<MenuItem> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            AutoSizeText(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 14,
              maxLines: 1,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(51),
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                items.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AutoSizeText(
                      item.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(RestaurantDetail restaurant) {
    final nameController = TextEditingController();
    final reviewController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AutoSizeText(
              'Customer Reviews',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              minFontSize: 14,
              maxLines: 1,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: AutoSizeText(
                restaurant.customerReviews.length.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 10,
                maxLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(51),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                'Add Your Review',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 14,
                maxLines: 1,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(fontSize: 12),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Consumer<AddReviewProvider>(
                builder: (context, addReviewProvider, child) {
                  final state = addReviewProvider.addReviewState;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is AddReviewErrorState)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            state.message,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (state is AddReviewSuccessState)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Review added successfully!',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          icon:
                              state is AddReviewLoadingState
                                  ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : const Icon(Icons.send),
                          label: Text(
                            state is AddReviewLoadingState
                                ? 'Submitting...'
                                : 'Submit Review',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          onPressed:
                              state is AddReviewLoadingState
                                  ? null
                                  : () {
                                    if (nameController.text.isEmpty ||
                                        reviewController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please fill all fields',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final request = AddReviewRequest(
                                      id: restaurant.id,
                                      name: nameController.text,
                                      review: reviewController.text,
                                    );

                                    addReviewProvider.addReview(request).then((
                                      _,
                                    ) {
                                      final currentState =
                                          addReviewProvider.addReviewState;
                                      if (currentState
                                          is AddReviewSuccessState) {
                                        context
                                            .read<RestaurantDetailProvider>()
                                            .fetchRestaurantDetail(
                                              restaurant.id,
                                            );

                                        nameController.clear();
                                        reviewController.clear();

                                        Future.delayed(
                                          const Duration(seconds: 3),
                                          () {
                                            addReviewProvider.resetState();
                                          },
                                        );
                                      }
                                    });
                                  },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        ...restaurant.customerReviews.map((review) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(51),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 16,
                      child: AutoSizeText(
                        review.name.isNotEmpty
                            ? review.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 10,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            review.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 0),
                          AutoSizeText(
                            review.date,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AutoSizeText(
                  review.review,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
                  minFontSize: 12,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
