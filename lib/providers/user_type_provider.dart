import 'package:flutter/material.dart';
import 'package:order_up/providers/auth.dart';

class UserTypeProvider extends ChangeNotifier {
  bool _isRestaurant = false;
  final Auth _auth;

  UserTypeProvider(this._auth);

  bool get isRestaurant => _isRestaurant;

  void updateIsRestaurant() {
    if (_auth.userType == 'c') {
      _isRestaurant = true;
    } else {
      _isRestaurant = false;
    }
    notifyListeners();
  }
}
