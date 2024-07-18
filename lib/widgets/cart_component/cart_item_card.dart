import 'package:flutter/material.dart';
import 'package:order_up/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final String productId;

  const CartItemCard(
      {super.key, required this.cartItem, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(productId),
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove item from the cart?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'))
                ],
              )),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CircleAvatar(
                child: FittedBox(
                    child: Image.network(
                  cartItem.image,
                  fit: BoxFit.cover,
                )),
              ),
            ),
            title: Text(cartItem.title),
            subtitle: Text(
                'Total: Rial ${cartItem.price * cartItem.quantity}       ${cartItem.amountType}'),
            trailing: Text('${cartItem.quantity} x'),
          ),
        ),
      ),
    );
  }
}
