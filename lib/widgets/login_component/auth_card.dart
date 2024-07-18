import 'dart:io';
import 'package:flutter/material.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/widgets/login_component/forget_password.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum AuthMode { Login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  bool _isObscure = true; // To toggle password visibility

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      // const errorMessage = 'Failed to authenticate. Please try again later';
      _showErrorDialog(error.toString());
      // print(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _callUs() async {
    const phoneNumber = 'tel: 730614064';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: deviceSize.height * 0.70,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!isValidEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isObscure,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!isValidPassword(value)) {
                      return 'Password must contain at least one uppercase letter, one number, and one special character';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgetPassword(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.black)),
                  child: Text('Forget Password?'),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _submit,
                        style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0)),
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.inversePrimary),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white)),
                        child: Text('LOGIN'),
                      ),
                      TextButton(
                        onPressed: _callUs,
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 4),
                            ),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black)),
                        child: Text('Call Us'),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  final RegExp passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  return passwordRegex.hasMatch(password);
}
