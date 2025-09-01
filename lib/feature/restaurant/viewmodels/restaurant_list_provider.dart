import 'package:flutter/material.dart';
import 'package:restaurant_app/feature/restaurant/services/restaurant_service.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_list_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  RestaurantListProvider(this._restaurantService);

  RestaurantListResultState _restaurantListState = RestaurantListInitialState();

  RestaurantListResultState get restaurantListState => _restaurantListState;

  Future<void> fetchRestaurantList() async {
    try {
      _restaurantListState = RestaurantListLoadingState();
      notifyListeners();

      final response = await _restaurantService.fetchRestaurantList();

      if (response.error) {
        _restaurantListState = RestaurantListErrorState(response.message);
        notifyListeners();
      } else {
        _restaurantListState = RestaurantListSuccessState(response.restaurants);
        notifyListeners();
      }
    } on Exception catch (e) {
      _restaurantListState = RestaurantListErrorState(e.toString());
      notifyListeners();
    }
  }
}
