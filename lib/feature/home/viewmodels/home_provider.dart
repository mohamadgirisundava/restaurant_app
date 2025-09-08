import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _themeMode =
          brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    } else {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLightMode() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setSystemMode() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  bool _isSearching = false;
  String _searchQuery = '';

  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;

  void startSearch(String query) {
    _isSearching = true;
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _searchQuery = '';
    notifyListeners();
  }
}
