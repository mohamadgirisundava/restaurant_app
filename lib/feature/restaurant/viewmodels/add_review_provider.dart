import 'package:flutter/material.dart';
import 'package:restaurant_app/feature/restaurant/models/add_review_request.dart';
import 'package:restaurant_app/feature/restaurant/services/restaurant_service.dart';
import 'package:restaurant_app/feature/restaurant/viewmodels/add_review_state.dart';

class AddReviewProvider extends ChangeNotifier {
  final RestaurantService _restaurantService;

  AddReviewProvider(this._restaurantService);

  AddReviewState _addReviewState = AddReviewInitialState();

  AddReviewState get addReviewState => _addReviewState;

  Future<void> addReview(AddReviewRequest request) async {
    try {
      _addReviewState = AddReviewLoadingState();
      notifyListeners();

      final response = await _restaurantService.addReview(request);

      if (response.error) {
        _addReviewState = AddReviewErrorState(response.message);
        notifyListeners();
      } else {
        _addReviewState = AddReviewSuccessState(response.customerReviews);
        notifyListeners();
      }
    } on Exception catch (e) {
      _addReviewState = AddReviewErrorState(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _addReviewState = AddReviewInitialState();
    notifyListeners();
  }
}
