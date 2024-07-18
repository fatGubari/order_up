import 'package:flutter/material.dart';
import 'package:order_up/items/search_for_supplier.dart';

class TapSearchBar extends StatelessWidget {
  const TapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: TextFormField(
            readOnly: true,
            onTap: () =>
                Navigator.of(context).pushNamed(SearchForSupplier.routeName),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    width: 0.5, color: Color.fromARGB(255, 0, 204, 7)),
              ),
              hintText: 'Search for a Supplier',
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.search, size: 30, color: Colors.white),
              suffixIcon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
            )),
      );
  }
}