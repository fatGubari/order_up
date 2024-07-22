import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:order_up/models/profile_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  late String _userId;
  Timer? _authTimer;
  String? _userType;
  ProfileData? profileData;
  String? _userName;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String? get userName {
    return _userName;
  }

  String? get userType {
    return _userType;
  }

  Future login(String email, String password) async {
    await _checkUserType(email, password);
  }

  Future _authenticate(String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB9iIqUoi9vBasvWiEr14lsrZForm27KqQ';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
        // 'email': email,
      });
      await prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future _checkUserType(String email, String password) async {
    try {
      // Check in restaurants collection
      var url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/restaurants.json';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        // print('Error fetching restaurants: ${response.statusCode} - ${response.body}');
        // await Future.delayed(Duration(milliseconds: 9000));
        throw Exception('Failed to fetch restaurants');
      }

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData != null) {
        // print('Checking restaurants...');

        for (var restData in extractedData.entries) {
          // print('Checking ${restData.value['email']}');
          if (restData.value['email'] == email) {
            _userType = 'restaurant';
            profileData = ProfileData(
              id: restData.key,
              name: restData.value['name'],
              email: email,
              location: restData.value['location'],
              phoneNumber: restData.value['phoneNumber'],
              image: restData.value['image'],
              password: password,
            );
            _userName = profileData?.name;
            await _authenticate(email, password, 'signInWithPassword');
            notifyListeners();
            return;
          }
        }
      }

      if (_userType == null) {
        url =
            'https://order-up-e0a41-default-rtdb.firebaseio.com/suppliers.json';
        response = await http.get(Uri.parse(url));

        if (response.statusCode != 200) {
          // print('Error fetching suppliers: ${response.statusCode} - ${response.body}');
          throw Exception('Failed to fetch suppliers');
        }

        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        print('Checking suppliers...');
        for (var suppData in extractedData.entries) {
          if (suppData.value['email'] == email) {
            _userType = 'supplier';
            print(userType);
            profileData = ProfileData(
              id: suppData.key,
              name: suppData.value['name'],
              email: email,
              location: suppData.value['location'],
              phoneNumber: suppData.value['phoneNumber'],
              image: suppData.value['image'],
              password: password,
              category: suppData.value['category'],
              rate: suppData.value['rate'].toString(),
            );
            _userName = profileData?.name;
            print(_userName);
            await _authenticate(email, password, 'signInWithPassword');
            notifyListeners();
            return;
          }
        }
      }
    } catch (error) {
      // print('Error in _checkUserType: $error');
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String?;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;

    await _checkUserType(
        extractedUserData['email'], extractedUserData['password']);

    // // Adding a delay to ensure the user type is set correctly
    // await Future.delayed(Duration(milliseconds: 500));

    if (_userType == null) {
      return false;
    }

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future logout() async {
    // Clear authentication-related variables
    _token = null;
    _userId = '';
    _expiryDate = null;
    _userType = null;

    // Reset additional user information

    // Cancel the automatic logout timer if active
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }

    // Notify listeners about the logout event
    notifyListeners();

    // Clear stored user data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logout);
  }

  Future sendPasswordResetEmail(String email) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyB9iIqUoi9vBasvWiEr14lsrZForm27KqQ';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'requestType': 'PASSWORD_RESET',
          'email': email,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future updateUserProfile({
    required String newName,
    required String newEmail,
    required String newPhoneNumber,
    required String? userType,
  }) async {
    // Determine the correct endpoint based on userType
    String userCollection =
        userType == 'restaurant' ? 'restaurants' : 'suppliers';
    // Fetch existing user data from Firebase
    final url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/$userCollection/$_userId.json?auth=$_token';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw HttpException('Failed to fetch user data.');
    }
    var bodyData = {};
    // Update user data in Firebase
    if (userType == 'restaurant') {
      bodyData = {
        'name': newName,
        'email': newEmail,
        'phoneNumber': newPhoneNumber,
        'location': profileData!.location,
        'image': profileData!.image,
        'password': profileData!.password
      };
    } else {
      bodyData = {
        'name': newName,
        'email': newEmail,
        'phoneNumber': newPhoneNumber,
        'location': profileData!.location,
        'image': profileData!.image,
        'password': profileData!.password,
        'rate': profileData!.rate,
        'category': profileData!.category,
      };
    }

    final updateResponse = await http.patch(
      Uri.parse(url),
      body: json.encode({...bodyData}),
    );

    if (updateResponse.statusCode == 200) {
      // Update local user data
      profileData = ProfileData(
        id: userId,
        name: newName,
        image: profileData?.image ?? '',
        email: newEmail,
        password: profileData?.password ?? '',
        phoneNumber: newPhoneNumber,
        location: profileData?.location ?? '',
      );

      notifyListeners();

      // Update SharedPreferences or any local storage if needed
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': userId,
        'expiryDate': _expiryDate?.toIso8601String(),
        'email': newEmail,
        'userType': userType,
      });
      await prefs.setString('userData', userData);
    } else {
      throw HttpException('Failed to update user profile.');
    }
  }

  Future updateUserPassword(
      {required String newPassword, required String? userType}) async {
    // Determine the correct endpoint based on userType
    String userCollection =
        userType == 'restaurant' ? 'restaurants' : 'suppliers';
    // Fetch existing user data from Firebase
    final url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/$userCollection/$_userId.json?auth=$_token';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw HttpException('Failed to fetch user data.');
    }
    var bodyData = {};
    // Update user data in Firebase
    if (userType == 'restaurant') {
      bodyData = {
        'name': profileData!.name,
        'email': profileData!.email,
        'phoneNumber': profileData!.phoneNumber,
        'location': profileData!.location,
        'image': profileData!.image,
        'password': newPassword
      };
    } else {
      bodyData = {
        'name': profileData!.name,
        'email': profileData!.email,
        'phoneNumber': profileData!.phoneNumber,
        'location': profileData!.location,
        'image': profileData!.image,
        'password': newPassword,
        'rate': profileData!.rate,
        'category': profileData!.category,
      };
    }

    final updateResponse = await http.patch(
      Uri.parse(url),
      body: json.encode({...bodyData}),
    );

    if (updateResponse.statusCode == 200) {
      // Update local user data
      profileData = ProfileData(
        id: userId,
        name: profileData?.name ?? '',
        image: profileData?.image ?? '',
        email: profileData?.email ?? '',
        password: newPassword,
        phoneNumber: profileData?.phoneNumber ?? '',
        location: profileData?.location ?? '',
      );

      notifyListeners();

      // Update SharedPreferences or any local storage if needed
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': userId,
        'expiryDate': _expiryDate?.toIso8601String(),
        'email': profileData!.email,
        'userType': userType,
      });
      await prefs.setString('userData', userData);
    } else {
      throw HttpException('Failed to update user profile.');
    }
  }
}
