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
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text('Orders Progress',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) {
                final inProgressOrders = orderData.inProgressOrders;
                if (inProgressOrders.isEmpty) {
                  return Center(
                      child: Text(
                    'No orders in progress',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ));
                }
                return ListView.builder(
                  itemCount: inProgressOrders.length,
                  itemBuilder: (context, index) {
                    final order = inProgressOrders[index];
                    return OrdersCard(
                      order: order,
                      index: index,
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
