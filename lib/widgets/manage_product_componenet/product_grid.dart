import 'package:flutter/material.dart';
import 'package:order_up/providers/products.dart';
import 'package:order_up/widgets/manage_product_componenet/product_items_card.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final searchController = TextEditingController();

  Future _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    Widget searchField() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 0.4),
            ),
            hintText: 'Search for a product',
            prefixIcon: Icon(
              Icons.search,
              size: 30,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                setState(() {});
              },
            ),
          ),
        ),
      );
    }

    List<Product> filteredProducts = products.productsData.where((product) {
      return product.title
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }).toList();

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: Column(
        children: [
          searchField(),
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ProductItemsCard(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
