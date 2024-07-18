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
        children:[
          // page background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(247, 119, 0, 1).withOpacity(0.5),
                  Color.fromRGBO(235, 197, 158, 1).withOpacity(0.9),
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
                children:[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 70.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.brown,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Order Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
