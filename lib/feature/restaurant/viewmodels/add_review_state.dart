import 'package:restaurant_app/feature/restaurant/models/restaurant_detail.dart';

sealed class AddReviewState {}

class AddReviewInitialState extends AddReviewState {}

class AddReviewLoadingState extends AddReviewState {}

class AddReviewSuccessState extends AddReviewState {
  final List<CustomerReview> customerReviews;

  AddReviewSuccessState(this.customerReviews);
}

class AddReviewErrorState extends AddReviewState {
  final String message;

  AddReviewErrorState(this.message);
}
