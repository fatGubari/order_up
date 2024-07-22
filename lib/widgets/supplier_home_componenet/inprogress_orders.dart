import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar_supplier.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/widgets/supplier_home_componenet/order_card_supplier.dart';
import 'package:provider/provider.dart';

class InprogressOrders extends StatefulWidget {
  const InprogressOrders({super.key});
  static const routeName = '/confirm-orders';

  @override
  State<InprogressOrders> createState() => _InprogressOrdersState();
}

class _InprogressOrdersState extends State<InprogressOrders> {
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
      drawer: SideBarSupplier(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text("Confirm the Orders",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                    child: Text('No Orders Yet',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  );
                }
                return ListView.builder(
                  itemCount: inProgressOrders.length,
                  itemBuilder: (ctx, i) =>
                      OrderCardSupplier(order: inProgressOrders[i], index: i),
                );
              },
            );
          }
        },
      ),
    );
  }
}
