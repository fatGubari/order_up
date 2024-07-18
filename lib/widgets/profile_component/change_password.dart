import 'package:flutter/material.dart';
import 'package:order_up/providers/auth.dart';
import 'package:provider/provider.dart';

class ChangePasswordDialog {
  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ChangePassword(),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();

  void show(BuildContext context) {}
}

class ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Password',),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _newPasswordController,
            decoration: InputDecoration(
              hintText: 'Enter new password',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm New Password',
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _handleChangePassword();
          },
          child: Text('Change'),
        ),
      ],
    );
  }

  void _handleChangePassword() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('Passwords cannot be empty.');
      return;
    }
    if (newPassword != confirmPassword) {
      _showErrorDialog('Passwords do not match.');
      return;
    }

    if (!_isPasswordValid(newPassword)) {
      _showErrorDialog('Password must contain at least 8 characters, one capital letter, and one special character.');
      return;
    }

        final authProvider = Provider.of<Auth>(context, listen: false);
    final String? userType = authProvider.userType;
    authProvider.updateUserPassword(
      newPassword: newPassword,
      userType: userType,
    );

    Navigator.of(context).pop();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error',style: TextStyle(color: Colors.red)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _isPasswordValid(String password) {
    // Password must contain at least 8 characters, one capital letter, and one special character
    final RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}|:"<>?]).{8,}$');
    return regex.hasMatch(password);
  }
}
