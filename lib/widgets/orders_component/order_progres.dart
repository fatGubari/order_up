// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/widgets/orders_component/orders_card.dart';
import 'package:provider/provider.dart';

class OrderProgres extends StatefulWidget {
  const OrderProgres({super.key});
  static const routeName = '/order-progress';

  @override
  State<OrderProgres> createState() => _OrderProgresState();
}

class _OrderProgresState extends State<OrderProgres> {
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    Future _refreshProducts(BuildContext context) async {
      await Provider.of<Orders>(context, listen: false).areAllOrdersCompleted();
    }

    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text('Orders Progress',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          itemCount: ordersData.orders.length,
          itemBuilder: (context, index) {
            final order = ordersData.orders[index];

            // Display only orders with 'Isn Progress' status
            if (order.status == 'In Progress') {
              return OrdersCard(
                order: order,
                index: index,
              );
            } else {
              return SizedBox.shrink(
                child: Text('No orders yet'),
              ); // Empty SizedBox if status is not 'In Progress'
            }
          },
        ),
      ),
    );
  }
}
