import 'package:flutter/material.dart';
import 'package:order_up/providers/suppliers.dart';
import 'package:order_up/widgets/supplier_lists_component/supplier_card.dart';
import 'package:provider/provider.dart';

class SearchForSupplier extends StatefulWidget {
  const SearchForSupplier({super.key});

  static const routeName = '/search-for-supplier';

  @override
  State<SearchForSupplier> createState() => _SearchForSupplierState();
}

class _SearchForSupplierState extends State<SearchForSupplier> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final suppliersData = Provider.of<Suppliers>(context);
    final suppliers = suppliersData.suppliers;

    Widget searchField() {
      return Padding(
        padding: const EdgeInsets.all(20.0),
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
            hintText: 'Search for a Supplier',
            prefixIcon: Icon(
              Icons.search,
              size: 30,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
              },
            ),
          ),
        ),
      );
    }

    Widget searchingList() {
      final filteredSuppliers = suppliers
          .where((supplier) => supplier.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();

      return Expanded(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: filteredSuppliers.isEmpty
              ? Center(
                  child: Text(
                    'No supplier found',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredSuppliers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SupplierCard(supplier: filteredSuppliers[index]);
                  },
                ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          searchField(),
          searchingList(),
        ],
      ),
    );
  }
}
