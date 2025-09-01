import 'package:restaurant_app/feature/restaurant/models/restaurant.dart';

sealed class RestaurantListResultState {}

class RestaurantListInitialState extends RestaurantListResultState {}

class RestaurantListLoadingState extends RestaurantListResultState {}

class RestaurantListSuccessState extends RestaurantListResultState {
  final List<Restaurant> data;

  RestaurantListSuccessState(this.data);
}

class RestaurantListErrorState extends RestaurantListResultState {
  final String message;

  RestaurantListErrorState(this.message);
}
