// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/feature/home/viewmodels/home_provider.dart';
import 'package:restaurant_app/feature/home/widgets/search_widget.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_list_state.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/search_restaurant_state.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/search_restaurant_provider.dart';

import '../../../core/widgets/loading_widget.dart';
import '../../restaurant/viewmodels/restaurant_list_provider.dart';
import '../../restaurant/widgets/restaurant_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      context.read<SearchRestaurantProvider>().searchRestaurant(query);
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
    });
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
          body: RefreshIndicator(
            onRefresh: () async {
              if (_isSearching) {
                _clearSearch();
              }
              context.read<RestaurantListProvider>().fetchRestaurantList();
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        SearchWidget(
                          searchController: _searchController,
                          onSearch: _performSearch,
                          onClear: _clearSearch,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          _isSearching ? 'Search Results' : 'All Restaurants',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 8,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          _isSearching
                              ? 'Results for "${_searchController.text}"'
                              : 'Discover places to eat around you',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          minFontSize: 8,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),

                _isSearching
                    ? Consumer<SearchRestaurantProvider>(
                      builder: (context, searchProvider, child) {
                        final searchState =
                            searchProvider.searchRestaurantState;

                        if (searchState is SearchRestaurantLoadingState) {
                          return SliverToBoxAdapter(child: LoadingWidget());
                        } else if (searchState is SearchRestaurantErrorState) {
                          return SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              width: double.infinity,
                              height: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off,
                                    size: 50,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(height: 15),
                                  AutoSizeText(
                                    searchState.message,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    minFontSize: 8,
                                    maxLines: 5,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
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
                                    onPressed: () {
                                      _performSearch(_searchController.text);
                                    },
                                    label: const Text(
                                      'Try Again',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (searchState
                            is SearchRestaurantSuccessState) {
                          final restaurants = searchState.data;

                          if (restaurants.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                width: double.infinity,
                                height: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.restaurant_menu,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 15),
                                    AutoSizeText(
                                      'No restaurants found for "${_searchController.text}"',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      minFontSize: 8,
                                      maxLines: 5,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        foregroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                      ).copyWith(
                                        overlayColor: WidgetStateProperty.all(
                                          Colors.transparent,
                                        ),
                                      ),
                                      onPressed: _clearSearch,
                                      label: const Text(
                                        'Show All Restaurants',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return SliverList.separated(
                            key: const ValueKey('search_results_list'),
                            itemCount: restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant = restaurants[index];
                              return RestaurantItemWidget(
                                key: ValueKey('search_${restaurant.id}'),
                                data: restaurant,
                              );
                            },
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 10),
                          );
                        } else {
                          return SliverToBoxAdapter(child: const SizedBox());
                        }
                      },
                    )
                    : Consumer<RestaurantListProvider>(
                      builder: (context, value, child) {
                        final state = value.restaurantListState;

                        if (state is RestaurantListLoadingState) {
                          return SliverToBoxAdapter(child: LoadingWidget());
                        } else if (state is RestaurantListErrorState) {
                          return SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              width: double.infinity,
                              height: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    size: 50,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(height: 15),
                                  AutoSizeText(
                                    state.message,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    minFontSize: 8,
                                    maxLines: 5,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
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
                                    onPressed: () {
                                      context
                                          .read<RestaurantListProvider>()
                                          .fetchRestaurantList();
                                    },
                                    label: const Text(
                                      'Try Again',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is RestaurantListSuccessState) {
                          return SliverList.separated(
                            key: const ValueKey('restaurant_list'),
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              final restaurant = state.data[index];
                              return RestaurantItemWidget(
                                key: ValueKey('restaurant_${restaurant.id}'),
                                data: restaurant,
                              );
                            },
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 10),
                          );
                        } else {
                          return SliverToBoxAdapter(child: const SizedBox());
                        }
                      },
                    ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        );
      },
    );
  }
}
