import 'package:flutter/material.dart';
import 'package:order_up/providers/cart.dart';
import 'package:order_up/widgets/cart_component/shopping_cart_screen.dart';
import 'package:provider/provider.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>( 
      builder: (_, cartData,__) =>  IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
        },

        icon: Badge(
          isLabelVisible: true,
          label: Text( cartData.itemCount.toString()),
          child: Icon(Icons.shopping_cart_outlined),
        )
    ));
  }
}