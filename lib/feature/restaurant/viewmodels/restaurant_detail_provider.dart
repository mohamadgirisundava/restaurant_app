import 'package:flutter/material.dart';
import 'package:restaurant_app/feature/restaurant/services/restaurant_service.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/restaurant_detail_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  RestaurantDetailProvider(this._restaurantService);

  RestaurantDetailState _restaurantDetailState = RestaurantDetailInitialState();

  RestaurantDetailState get restaurantDetailState => _restaurantDetailState;

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _restaurantDetailState = RestaurantDetailLoadingState();
      notifyListeners();

      final response = await _restaurantService.fetchRestaurantDetail(id);

      if (response.error) {
        _restaurantDetailState = RestaurantDetailErrorState(response.message);
        notifyListeners();
      } else {
        _restaurantDetailState = RestaurantDetailSuccessState(
          response.restaurant,
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      _restaurantDetailState = RestaurantDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}
