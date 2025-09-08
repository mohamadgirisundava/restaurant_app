import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/static/navigation_route.dart';
import 'package:restaurant_app/core/style/themes/main_theme.dart';
import 'package:restaurant_app/feature/home/viewmodels/home_provider.dart';
import 'package:restaurant_app/feature/main/viewmodels/index_nav_provider.dart';
import 'package:restaurant_app/feature/main/views/main_screen.dart';
import 'package:restaurant_app/feature/restaurant/models/restaurant.dart';
import 'package:restaurant_app/feature/restaurant/services/restaurant_service.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_bookmark_provider.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_detail_provider.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_list_provider.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/search_restaurant_provider.dart';
import 'package:restaurant_app/feature/restaurant/views/restaurant_detail_screen.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/add_review_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IndexNavProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        Provider(create: (context) => RestaurantService()),
        ChangeNotifierProvider(
          create:
              (context) =>
                  RestaurantListProvider(context.read<RestaurantService>()),
        ),
        ChangeNotifierProvider(create: (_) => RestaurantBookmarkProvider()),
        ChangeNotifierProvider(
          create:
              (context) =>
                  SearchRestaurantProvider(context.read<RestaurantService>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  RestaurantDetailProvider(context.read<RestaurantService>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => AddReviewProvider(context.read<RestaurantService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Restaurant App',
          theme: MainTheme.lightTheme,
          darkTheme: MainTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          initialRoute: '/',
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name:
                (context) => RestaurantDetailScreen(
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as Restaurant,
                ),
          },
        );
      },
    );
  }
}
