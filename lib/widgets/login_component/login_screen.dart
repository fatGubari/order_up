import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:order_up/widgets/home_component/resturant_mainpage_screen.dart';
import 'package:order_up/widgets/login_component/auth_card.dart';
// import 'package:order_up/widgets/login_component/forget_password.dart';
// import 'package:order_up/widgets/supplier_home_componenet/supplier_homepage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  final double defaultPadding = 16.0;
  static const routeName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // page background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color.fromARGB(255, 245, 239, 223),
                  // Color.fromARGB(255, 236, 226, 198),
                  Color.fromARGB(255, 199, 175, 91),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 70.0),
                      child: Image.asset('assets/images/logo_blue.png'),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
