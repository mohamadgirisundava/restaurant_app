import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/feature/restaurant/models/restaurant_list_response.dart';
import 'package:restaurant_app/feature/restaurant/models/search_restaurant_response.dart';
import 'package:restaurant_app/feature/restaurant/models/restaurant_detail_response.dart';
import 'package:restaurant_app/feature/restaurant/models/add_review_request.dart';
import 'package:restaurant_app/feature/restaurant/models/add_review_response.dart';

class RestaurantService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> fetchRestaurantList() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    try {
      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SearchRestaurantResponse> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));

    try {
      if (response.statusCode == 200) {
        return SearchRestaurantResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantDetailResponse> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));

    try {
      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AddReviewResponse> addReview(AddReviewRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/review'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddReviewResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      rethrow;
    }
  }
}
