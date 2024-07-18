import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar_supplier.dart';
import 'package:order_up/widgets/manage_product_componenet/add_edit_product.dart';
import 'package:order_up/widgets/manage_product_componenet/product_grid.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});
  static const routeName = '/manage-product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarSupplier(),
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: Text('Manage Product',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddEditProduct.routeName);
                },
                icon: const Icon(Icons.add))
          ]),
      body: ProductGrid(),
    );
  }
}
