import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar_supplier.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/widgets/supplier_home_componenet/all_orders.dart';
import 'package:order_up/widgets/supplier_home_componenet/order_card_supplier.dart';
import 'package:provider/provider.dart';

class SupplierHomepage extends StatefulWidget {
  const SupplierHomepage({super.key});
  static const routeName = '/supplier-home';

  @override
  State<SupplierHomepage> createState() => _SupplierHomepageState();
}

class _SupplierHomepageState extends State<SupplierHomepage> {
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
    final orders = ordersData.orders
        .where((order) => order.status == 'In Progress')
        .toList();
    return Scaffold(
      drawer: SideBarSupplier(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text("Order UP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: ordersData.orders.isEmpty || ordersData.areAllOrdersCompleted()
          ? Center(
              child: Text('No Orders Yet',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)))
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
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Consumer<Orders>(
                        builder: (ctx, orderData, child) => ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (ctx, i) =>
                                  OrderCardSupplier(order: orders[i], index: i),
                            ));
                  }
                }
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AllOrders.routeName),
        tooltip: 'Checked Orders',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Icon(Icons.fact_check_outlined),
      ),
    );
  }
}
