import 'package:restaurant_app/feature/restaurant/models/restaurant_detail.dart';

sealed class RestaurantDetailState {}

class RestaurantDetailInitialState extends RestaurantDetailState {}

class RestaurantDetailLoadingState extends RestaurantDetailState {}

class RestaurantDetailSuccessState extends RestaurantDetailState {
  final RestaurantDetail data;

  RestaurantDetailSuccessState(this.data);
}

class RestaurantDetailErrorState extends RestaurantDetailState {
  final String message;

  RestaurantDetailErrorState(this.message);
}
