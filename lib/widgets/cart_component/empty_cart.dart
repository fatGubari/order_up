import 'package:flutter/material.dart';
import 'package:order_up/widgets/home_component/resturant_mainpage_screen.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/shopping_cart.png',
              height: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your Shopping Cart is Empty',
              style:
                  TextStyle(fontSize: 16, color: Colors.black.withOpacity(.6)),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Fortunately, there is an essay solution. ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed(ResturantMainPageScreen.routeName),
                  child: const Text('Go Shopping')),
            ),
          ],
        ),
      ),
    );
  }
}
