import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_up/providers/order.dart';

class ConfirmedOrderCard extends StatefulWidget {
  final OrdersItem order;

  const ConfirmedOrderCard({
    super.key,
    required this.order,
  });

  @override
  State<ConfirmedOrderCard> createState() => _ConfirmedOrderCardState();
}

class _ConfirmedOrderCardState extends State<ConfirmedOrderCard> {
  bool _isExpanded = false; // Track if the details are expanded

  @override
  Widget build(BuildContext context) {
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
                  Text('Restaurant: ${widget.order.resturantName}'),
                  Text('Status: ${widget.order.status}'),
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
                        _isExpanded = !_isExpanded; // Toggle the expanded state
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
                  children: widget.order.products.map((product) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product: ${product.title}'),
                          Text('Price: Rial ${product.price}'),
                          Text('Amount Type: ${product.amountType}'),
                          Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
