import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/order.dart';
import 'package:provider/provider.dart';

class OrderCardSupplier extends StatefulWidget {
  final OrdersItem order;
  final int index;

  const OrderCardSupplier(
      {super.key, required this.order, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _OrderCardSupplierState createState() => _OrderCardSupplierState();
}

class _OrderCardSupplierState extends State<OrderCardSupplier> {
  bool _isExpanded = false;
  bool _isConfirmed = false; // Track if the order is confirmed

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    final orderDetails = ordersData.getSupplierAndAmount(widget.order);
    // final supplierName = Provider.of<Auth>(context).userName;

    if (_isConfirmed) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 9.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.order.id,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                      'Date: ${DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)}'),
                  Text('Price: Rial ${widget.order.amount}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      ordersData.confirmOrder(widget.order.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('You Confirmed The Order'),
                        duration: Duration(seconds: 2),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ));
                      setState(() {
                        _isConfirmed = true; // Set the order as confirmed
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      ordersData.cancelOrder(widget.order.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('You Cancled The Order'),
                        duration: Duration(seconds: 2),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(_isExpanded ? 'Show Less' : 'Show More'),
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text('Resturnt: ${widget.order.resturantName}'),
                    ...orderDetails.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text('Supplier: ${entry.key}'),
                            ...entry.value.map((product) => Text(
                                'Product: ${product['title']}, Price: ${product['price']}, Amount Type: ${product['amountType']}')),
                            SizedBox(height: 4.0),
                          ],
                        )),
                    Divider(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
