import 'package:flutter/material.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/cart.dart';
import 'package:order_up/widgets/cart_component/cart_item_card.dart';
import 'package:order_up/widgets/cart_component/confirm_order.dart';
import 'package:provider/provider.dart';

class CartBody extends StatelessWidget {
  const CartBody({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final restaurantId = Provider.of<Auth>(context).userId;
    return Flexible(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      'Rial ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showConfirmationDialog(context, cart, restaurantId);
                    },
                    child: const Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) => CartItemCard(
                        cartItem: cart.items.values.toList()[index],
                        productId: cart.items.keys.toList()[index],
                      ),
                  itemCount: cart.items.length))
        ],
      ),
    );
  }
}
