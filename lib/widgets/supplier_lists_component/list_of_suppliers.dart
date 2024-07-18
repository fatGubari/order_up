import 'package:flutter/material.dart';
import 'package:order_up/providers/suppliers.dart';
import 'package:order_up/widgets/supplier_lists_component/supplier_card.dart';
import 'package:provider/provider.dart';

class ListOfSuppliers extends StatefulWidget {
  const ListOfSuppliers({super.key});

  @override
  State<ListOfSuppliers> createState() => _ListOfSuppliersState();
}

class _ListOfSuppliersState extends State<ListOfSuppliers> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Suppliers>(context, listen: false)
        .fetchAndSetSuppliers();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final suppliersData = Provider.of<Suppliers>(context);
    final suppliers = suppliersData.suppliers;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
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
              return Consumer<Suppliers>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: suppliers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SupplierCard(supplier: suppliers[index]);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
