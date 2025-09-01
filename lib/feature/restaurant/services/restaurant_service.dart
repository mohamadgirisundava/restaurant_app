import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/feature/restaurant/models/restaurant_list_response.dart';

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
      throw Exception(e.toString());
    }
  }
}
