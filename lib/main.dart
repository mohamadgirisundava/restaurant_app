import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/static/navigation_route.dart';
import 'package:restaurant_app/core/style/themes/main_theme.dart';
import 'package:restaurant_app/feature/home/screens/home_screen.dart';
import 'package:restaurant_app/feature/home/providers/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
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
      ),
    );
  }
}
