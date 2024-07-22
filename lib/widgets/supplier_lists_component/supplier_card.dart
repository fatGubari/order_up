import 'package:flutter/material.dart';
import 'package:order_up/providers/suppliers.dart';
import 'package:order_up/widgets/chat_component/chat_screen.dart';
import 'package:order_up/widgets/supplier_lists_component/suppliers_screens.dart';

class SupplierCard extends StatelessWidget {
  final Supplier supplier;

  const SupplierCard({super.key, required this.supplier});

  // use this function to navigat throw the listView and send the object of each
  void selectSupplier(BuildContext context) {
    // 3
    Navigator.of(context).pushNamed(
      SuppliersScreens.routeName,
      arguments: supplier,
    );
  }

  void chatSupplier(BuildContext context) {
    Navigator.of(context).pushNamed(
      // SuppliersScreens.routeName,
      ChatScreen.routeName,
      arguments: {
        'id': supplier.id,
        'imageURL': supplier.image,
        'name': supplier.name
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectSupplier(context),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        elevation: 5,
        child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: ClipOval(
                child: Image.network(
                  supplier.image,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            title: Text(
              supplier.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(supplier.location),
            trailing: IconButton(
              icon: Icon(Icons.message_outlined),
              onPressed: () => chatSupplier(context),
              color: Theme.of(context).colorScheme.inversePrimary,
            )),
      ),
    );
  }
}
