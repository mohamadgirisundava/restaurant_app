import 'package:flutter/material.dart';
import 'package:restaurant_app/feature/restaurant/services/restaurant_service.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/search_restaurant_state.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  SearchRestaurantProvider(this._restaurantService);

  SearchRestaurantState _searchRestaurantState = SearchRestaurantInitialState();

  SearchRestaurantState get searchRestaurantState => _searchRestaurantState;

  Future<void> searchRestaurant(String query) async {
    try {
      _searchRestaurantState = SearchRestaurantLoadingState();
      notifyListeners();

      final response = await _restaurantService.searchRestaurant(query);

      if (response.error) {
        _searchRestaurantState = SearchRestaurantErrorState(
          'Failed to search restaurants',
        );
        notifyListeners();
      } else {
        _searchRestaurantState = SearchRestaurantSuccessState(
          response.restaurants,
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      _searchRestaurantState = SearchRestaurantErrorState(e.toString());
      notifyListeners();
    }
  }
}
