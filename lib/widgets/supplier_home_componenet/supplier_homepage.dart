import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar_supplier.dart';
import 'package:order_up/widgets/supplier_home_componenet/all_orders.dart';
import 'package:order_up/widgets/supplier_home_componenet/inprogress_orders.dart';

class SupplierHomepage extends StatefulWidget {
  const SupplierHomepage({super.key});
  static const routeName = '/supplier-home';

  @override
  State<SupplierHomepage> createState() => _SupplierHomepageState();
}

class _SupplierHomepageState extends State<SupplierHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarSupplier(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text("Order UP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.check_box_outlined,
                size: 50,
              ),
              Icon(
                Icons.disabled_by_default_outlined,
                size: 50,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Orders Need to confirm',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Once you Confirm the Order the Restaurnt will be Notify',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(InprogressOrders.routeName),
              child: Text('Confirm the orders'))
        ],
      ),
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
