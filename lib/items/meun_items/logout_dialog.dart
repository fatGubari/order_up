import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Logout'),
      content: SingleChildScrollView(
        child: ListBody(
          children:const [
            Text('Are you sure you want to log out?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Logout'),
          onPressed: () {
            // Perform logout action here
            onLogout();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
