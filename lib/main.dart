import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/static/navigation_route.dart';
import 'package:restaurant_app/core/style/themes/main_theme.dart';
import 'package:restaurant_app/feature/home/views/home_screen.dart';
import 'package:restaurant_app/feature/home/viewmodels/home_provider.dart';
import 'package:restaurant_app/feature/restaurant/services/restaurant_service.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/bookmark_restaurant_provider.dart';

import 'feature/restaurant/viewmodels/restaurant_list_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (context) => RestaurantService()),
        ChangeNotifierProvider(
          create:
              (context) =>
                  RestaurantListProvider(context.read<RestaurantService>()),
        ),
        ChangeNotifierProvider(create: (_) => BookmarkRestaurantProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
            NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
            // NavigationRoute.detailRoute.name:
            // (context) => DetailScreen(
            // tourismId: ModalRoute.of(context)?.settings.arguments as int,
            // ),
          },
        );
      },
    );
  }
}
