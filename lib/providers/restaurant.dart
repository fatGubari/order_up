import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Restaurants with ChangeNotifier {
  List<Restaurant> _restaurants = [];

  List<Restaurant> get restaurants {
    return [..._restaurants];
  }

  Future fetchAndSetRestaurants() async {
    const url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/restaurants.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final List<Restaurant> loadedRestaurants = [];
        if (extractedData != null) {
          extractedData.forEach((restId, restData) {
            loadedRestaurants.add(Restaurant(
              id: restId,
              name: restData['name'],
              location: restData['location'],
              image: restData['image'],
              email: restData['email'],
              password: restData['password'],
              phoneNumber: restData['phoneNumber'],
            ));
          });
        }
        _restaurants = loadedRestaurants;
        notifyListeners();
      } else {}
    } catch (error) {
      rethrow;
    }
  }

  Future updateRestaurant(String id, Restaurant newRestaurant) async {
    final restaurantIndex = restaurants.indexWhere((rest) => rest.id == id);
    if (restaurantIndex >= 0) {
      final url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/restaurants/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'name': newRestaurant.name,
            'location': newRestaurant.location,
            'image': newRestaurant.image,
            'email': newRestaurant.email,
            'password': newRestaurant.password,
            'phoneNumber': newRestaurant.phoneNumber,
          }));

      _restaurants[restaurantIndex] = newRestaurant;
      notifyListeners();
    }
  }
}

class Restaurant {
  final String id;
  final String name;
  final String location;
  final String image;
  final String email;
  final String password;
  final String phoneNumber;

  Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
}
