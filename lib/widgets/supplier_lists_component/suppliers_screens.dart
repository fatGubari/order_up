import 'package:flutter/material.dart';
import 'package:order_up/widgets/cart_component/cart_button.dart';
import 'package:order_up/providers/products.dart';
import 'package:order_up/providers/suppliers.dart';
import 'package:order_up/widgets/chat_component/chat_screen.dart';
import 'package:order_up/widgets/product_component/product_card.dart';
import 'package:provider/provider.dart';

class SuppliersScreens extends StatefulWidget {
  const SuppliersScreens({super.key});

  static const routeName = '/suppliers-screen';

  @override
  State<SuppliersScreens> createState() => _SuppliersScreensState();
}

class _SuppliersScreensState extends State<SuppliersScreens> {
  late Future _productsFuture;

  Future _obtainProductsFuture() {
    return Provider.of<Products>(context, listen: false)
        .fetchAndSetProductsForRestaurant();
  }

  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  void chatSupplier(
    BuildContext context,
    String name,
    String id,
    String image,
  ) {
    Navigator.of(context).pushNamed(
      // SuppliersScreens.routeName,
      ChatScreen.routeName,
      arguments: {'id': id, 'imageURL': image, 'name': name},
    )
        // .whenComplete(() => Navigator.pop(context)).then((value) => Navigator.pop(context))
        ;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Supplier;

    void showSupplierInfo(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: CircleAvatar(
            radius: 60.0,
            backgroundImage: NetworkImage(routeArgs.image),
            onBackgroundImageError: (exception, stackTrace) => exception,
          ),
          contentPadding: EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  routeArgs.name,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 13),
                Text(routeArgs.location),
                SizedBox(height: 13),
                Text('Category: ${routeArgs.category}'),
                SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      routeArgs.rate.toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.star,
                      color: const Color.fromARGB(255, 255, 200, 71),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => chatSupplier(
                          context,
                          routeArgs.name,
                          routeArgs.id,
                          routeArgs.image,
                        ),
                    child: Icon(Icons.message_outlined)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          routeArgs.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [CartButton()],
      ),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<Products>(
              builder: (ctx, productData, child) {
                // print('Products: ${productData.products}');
                final merchandise = productData.products
                    .where((product) => product.supplier == routeArgs.name)
                    .toList();
                // print(productData.products.first);
                print('Filtered Merchandise: $merchandise');
                if (merchandise.isEmpty) {
                  return Center(
                      child: Text('No products found for this supplier.'));
                }
                return ListView.builder(
                  itemCount: merchandise.length,
                  itemBuilder: (context, index) {
                    return ProductCard(merchandiseCard: merchandise[index]);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showSupplierInfo(context),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        tooltip: 'Supplier Info',
        child: Icon(Icons.info_outline),
      ),
    );
  }
}
