import 'package:flutter/material.dart';
import 'package:order_up/providers/cart.dart';
import 'package:order_up/widgets/cart_component/cart_body.dart';
import 'package:order_up/widgets/cart_component/empty_cart.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});
  static const routeName = '/shopping-cart-screen';
  
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // Receive the list of ShoppingItem objec
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: cart.items.isEmpty? EmptyCart(): CartBody()
    );
  }
}
