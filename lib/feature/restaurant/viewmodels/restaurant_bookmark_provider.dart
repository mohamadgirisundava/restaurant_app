import 'package:flutter/material.dart';
import 'package:restaurant_app/feature/restaurant/models/restaurant.dart';

class RestaurantBookmarkProvider extends ChangeNotifier {
  final List<Restaurant> _bookmarkList = [];

  List<Restaurant> get bookmarkList => _bookmarkList;

  bool isBookmarked(String id) {
    return _bookmarkList.any((restaurant) => restaurant.id == id);
  }

  void toggleBookmark(Restaurant restaurant) {
    if (isBookmarked(restaurant.id)) {
      removeBookmark(restaurant);
    } else {
      addBookmark(restaurant);
    }
  }

  void addBookmark(Restaurant value) {
    if (!isBookmarked(value.id)) {
      _bookmarkList.add(value);
      notifyListeners();
    }
  }

  void removeBookmark(Restaurant value) {
    _bookmarkList.removeWhere((element) => element.id == value.id);
    notifyListeners();
  }

  bool checkItemBookmark(Restaurant value) {
    return _bookmarkList.any((element) => element.id == value.id);
  }
}
