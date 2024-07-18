import 'package:flutter/material.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/cart.dart';
import 'package:order_up/providers/order.dart';
import 'package:provider/provider.dart';

void showConfirmationDialog(
  BuildContext context,
  Cart cart,
  String restaurantId,
) {
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final restaurantName = Provider.of<Auth>(context).userName;
      bool isLoading = false;
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to confirm the order?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Order confirmed!',
                    style: TextStyle(color: Colors.black),
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ));
                await Provider.of<Orders>(context, listen: false).addOrder(
                    cart.items.values.toList(),
                    cart.totalAmount,
                    restaurantName!,
                    restaurantId);
                setState(() {
                  isLoading = false;
                });
                cart.clear();
                // ignore: use_build_context_synchronously
                Navigator.pop(context); // Close the dialog
              },
              child: isLoading ? CircularProgressIndicator() : Text("Confirm"),
            ),
          ],
        );
      });
    },
  );
}
