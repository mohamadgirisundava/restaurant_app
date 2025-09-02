import 'package:restaurant_app/feature/restaurant/models/restaurant.dart';

sealed class SearchRestaurantState {}

class SearchRestaurantInitialState extends SearchRestaurantState {}

class SearchRestaurantLoadingState extends SearchRestaurantState {}

class SearchRestaurantSuccessState extends SearchRestaurantState {
  final List<Restaurant> data;

  SearchRestaurantSuccessState(this.data);
}

class SearchRestaurantErrorState extends SearchRestaurantState {
  final String message;

  SearchRestaurantErrorState(this.message);
}
