import 'package:flutter/material.dart';
import 'package:order_up/providers/products.dart';
import 'package:order_up/widgets/manage_product_componenet/add_edit_product.dart';
import 'package:order_up/widgets/manage_product_componenet/show_product_details.dart';
import 'package:provider/provider.dart';

class ProductItemsCard extends StatelessWidget {
  final Product product;
  const ProductItemsCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(context, product.id);
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddEditProduct.routeName, arguments: product.id);
            },
            color: Colors.black,
          ),
        ),
        child: GestureDetector(
          onTap: () => showProductDetails(context, product),
          child: Image.network(
            product.image[0],
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Icon(
                Icons.production_quantity_limits,
                size: 50,
              );
            },
          ),
        ),
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, String productId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final scaffoldMessage = ScaffoldMessenger.of(context);
      return AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this product?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                Provider.of<Products>(context, listen: false)
                    .deleteProduct(productId.toString());
                Navigator.of(context).pop();
              } catch (e) {
                scaffoldMessage.showSnackBar(SnackBar(
                    content: Text(
                  'Deleting faild!',
                  textAlign: TextAlign.center,
                )));
              }
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
