import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:restaurant_app/feature/restaurant/models/restaurant_list_response.dart';
import 'package:restaurant_app/feature/restaurant/models/search_restaurant_response.dart';
import 'package:restaurant_app/feature/restaurant/models/restaurant_detail_response.dart';
import 'package:restaurant_app/feature/restaurant/models/add_review_request.dart';
import 'package:restaurant_app/feature/restaurant/models/add_review_response.dart';

class RestaurantService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> fetchRestaurantList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list'));
      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load restaurant list. Please try again later.',
        );
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      rethrow;
    }
  }

  Future<SearchRestaurantResponse> searchRestaurant(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));
      if (response.statusCode == 200) {
        return SearchRestaurantResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load search results. Please try again later.',
        );
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantDetailResponse> fetchRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/detail/$id'));
      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load restaurant details. Please try again later.',
        );
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      rethrow;
    }
  }

  Future<AddReviewResponse> addReview(AddReviewRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddReviewResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add review. Please try again later.');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      rethrow;
    }
  }
}
