import 'package:flutter/material.dart';
import 'package:order_up/widgets/login_component/new_password.dart';

class ForgetEmail extends StatefulWidget {
  final String email;
  const ForgetEmail({super.key, required this.email});

  @override
  _ForgetEmailState createState() => _ForgetEmailState();
}

class _ForgetEmailState extends State<ForgetEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  String? _sentCode; // This should be set when sending the code to the email

  @override
  void initState() {
    super.initState();
    // Send the code to the email
    _sendCodeToEmail();
  }

  void _sendCodeToEmail() {
    // Logic to send the code to the user's email
    // For example, using Firebase functions to send the email with the code

    // Placeholder code: replace this with your actual code sending logic
    _sentCode = "123456"; // This should be the actual code sent to the user's email
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_codeController.text == _sentCode) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPassword(
              email: widget.email,
              code: _sentCode!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid code. Please try again.'),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Enter the Code",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "__   __   __   __   __   __",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the code';
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                onPressed: _sendCodeToEmail,
                child: Text(
                  "Re-Send The Code",
                  style: TextStyle(
                    color: Color.fromARGB(255, 9, 8, 8),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Text(
                  "Confirm",
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
