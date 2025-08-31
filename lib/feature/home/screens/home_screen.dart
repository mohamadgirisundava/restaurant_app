import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/feature/home/providers/home_provider.dart';
import 'package:restaurant_app/feature/home/widgets/search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> restaurants = [
    {
      'name': 'Melting Pot',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'pictureId': 'https://restaurant-api.dicoding.dev/images/medium/14',
      'city': 'Medan',
      'rating': '4.2',
    },
    {
      'name': 'Kafe Kita',
      'description': 'Quisque rutrum. Aenean imperdiet.',
      'pictureId': 'https://restaurant-api.dicoding.dev/images/medium/25',
      'city': 'Gorontalo',
      'rating': '4.0',
    },
    {
      'name': 'Bring Your Phone Cafe',
      'description': 'Maecenas ut massa quis augue luctus tincidunt.',
      'pictureId': 'https://restaurant-api.dicoding.dev/images/medium/03',
      'city': 'Balikpapan',
      'rating': '4.6',
    },
    {
      'name': 'Kafein',
      'description': 'Proin vel arcu eu odio tristique pharetra.',
      'pictureId': 'https://restaurant-api.dicoding.dev/images/medium/15',
      'city': 'Aceh',
      'rating': '4.1',
    },
    {
      'name': 'Gigitan Makro',
      'description': 'Sed in libero ut nibh placerat accumsan.',
      'pictureId': 'https://restaurant-api.dicoding.dev/images/medium/02',
      'city': 'Malang',
      'rating': '4.3',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Restaurant',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: 22),
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
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      SearchWidget(searchController: _searchController),
                      const SizedBox(height: 20),
                      Text(
                        'All Restaurants',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SliverList.separated(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              restaurant['pictureId']!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.restaurant,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  restaurant['name']!,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    AutoSizeText(
                                      restaurant['rating']!,
                                      style: TextStyle(
                                        color: Colors.amber[700],
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
                                  restaurant['description']!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  minFontSize: 8,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey[500],
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    AutoSizeText(
                                      restaurant['city']!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      minFontSize: 8,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.bookmark_border,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder:
                    (context, index) => const SizedBox(height: 10),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10)),
            ],
          ),
        );
      },
    );
  }
}
