// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NotificationService {
  static void showAddedToCartNotification(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green, // Set background color
      content: Row(
        children: const [
          Icon(Icons.check_circle_outline, color: Colors.white), // Icon
          SizedBox(width: 10),
          Text(
            'Item added to the cart', // Notification message
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      duration: Duration(seconds: 2), // Duration for how long the notification will be displayed
      behavior: SnackBarBehavior.floating, // Set behavior to floating for a floating effect
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}