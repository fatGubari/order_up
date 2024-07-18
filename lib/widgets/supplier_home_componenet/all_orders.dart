import 'package:flutter/material.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/widgets/supplier_home_componenet/confirmed_order_card.dart';
import 'package:provider/provider.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});
  static const routeName = '/all-orders';

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
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
    final ordersData = Provider.of<Orders>(context);
    final confirmedOrders = ordersData.confirmedOrders;
    return Scaffold(
      appBar: AppBar(
        title: Text('All Orders',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: confirmedOrders.isEmpty
          ? Center(
              child: Text(
                'No Confirmed Orders Yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : FutureBuilder(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.error != null) {
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: confirmedOrders.length,
                        itemBuilder: (ctx, i) => ConfirmedOrderCard(
                          order: confirmedOrders[i],
                        ),
                      ),
                    );
                  }
                }
              },
            ),
    );
  }
}
