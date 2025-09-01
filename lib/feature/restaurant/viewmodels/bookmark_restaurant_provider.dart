import 'package:flutter/material.dart';

class BookmarkRestaurantProvider extends ChangeNotifier {
  final Set<String> _bookmarkedIds = {};

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
  }
}
