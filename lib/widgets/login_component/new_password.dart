import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:order_up/widgets/login_component/login_screen.dart';
import 'package:http/http.dart' as http;

class NewPassword extends StatefulWidget {
  final String email;
  final String code; // Add this to receive the code from the previous step

  const NewPassword({super.key, required this.email, required this.code});

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isValidPassword(String password) {
    final RegExp regex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return regex.hasMatch(password);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _resetPassword(widget.code, _passwordController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset password: $error'),
          ),
        );
      }
    }
  }

  Future<void> _resetPassword(String code, String newPassword) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=AIzaSyB9iIqUoi9vBasvWiEr14lsrZForm27KqQ';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'oobCode': code,
        'newPassword': newPassword,
      }),
    );

    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw Exception(responseData['error']['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Up',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Remember It',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _passwordController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Enter New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (!isValidPassword(value)) {
                          return 'Password must contain at least one uppercase letter, one number, and one special character';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Confirm New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Color.fromARGB(255, 9, 8, 8),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
