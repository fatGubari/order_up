import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_up/providers/order.dart';
import 'package:provider/provider.dart';

class OrdersCard extends StatefulWidget {
  final OrdersItem order;
  final int index;
  const OrdersCard({super.key, required this.order, required this.index});

  @override
  State<OrdersCard> createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  List<bool> _expandedList = [];

  @override
  Widget build(BuildContext context) {
    final orderDetails =
        Provider.of<Orders>(context).getSupplierAndAmount(widget.order);
    final ordersData = Provider.of<Orders>(context);
    final orders = ordersData.orders;

    if (_expandedList.length != orders.length) {
      _expandedList = List<bool>.filled(orders.length, false);
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
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Date: ${DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)}',
                  ),
                  SizedBox(width: 20.0),
                  Text('Price: Rial ${widget.order.amount}'),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expandedList[widget.index] = !_expandedList[widget.index];
                  });
                },
                icon: Icon(
                  _expandedList[widget.index]
                      ? Icons.expand_less
                      : Icons.expand_more,
                ),
              ),
            ),
            if (_expandedList[widget.index])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...orderDetails.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text('Supplier: ${entry.key}'),
                            Text('Product Info: ${entry.value.join(', ')}'),
                            SizedBox(height: 4.0),
                          ],
                        )),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order Status:'),
                          Text(
                            widget.order
                                .status, // Call the method to determine status
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.order.status == 'In Progress'
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
