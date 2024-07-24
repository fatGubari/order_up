import 'package:flutter/material.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/widgets/login_component/login_screen.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  static const routeName = '/forget-password';

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final double defaultPadding = 16.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .sendPasswordResetEmail(_emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent!'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send password reset email: $error'),
          ),
        );
      }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Enter Your Email to Send The Code',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!isValidEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _submit,
                 style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).iconTheme.color),
              foregroundColor: WidgetStatePropertyAll(Colors.black),
            ),
              child: Text(
                "confirm",
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
    );
  }
}
