import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Suppliers with ChangeNotifier {
  List<Supplier> _suppliers = [];

  List<Supplier> get suppliers {
    return [..._suppliers];
  }

  Future fetchAndSetSuppliers() async {
    const url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/suppliers.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        final List<Supplier> loadedSupplier = [];
        if (extractedData != null) {
          extractedData.forEach((suppId, suppData) {
            loadedSupplier.add(Supplier(
              id: suppId,
                name: suppData['name'] ?? '', 
              location: suppData['location'] ?? '',
              image: suppData['image'] ?? '',
              email: suppData['email'] ?? '',
              password: suppData['password'] ?? '',
              phoneNumber: suppData['phoneNumber'] ?? '',
              category: suppData['category'] ?? '',
              rate: suppData['rate'] is double
                  ? suppData['rate']
                  : double.tryParse(suppData['rate'].toString()) ?? 0.0,
            ));
          });
        }
        _suppliers = loadedSupplier;
        notifyListeners();
      } else {
        // print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  Future updateSupplier(String id, Supplier newSupplier) async {
    final supplierIndex = suppliers.indexWhere((supp) => supp.id == id);
    if (supplierIndex >= 0) {
      final url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/suppliers/$id.json';

      await http.patch(Uri.parse(url),
          body: json.encode({
            'name': newSupplier.name,
            'location': newSupplier.location,
            'image': newSupplier.image,
            'email': newSupplier.email,
            'password': newSupplier.password,
            'phoneNumber': newSupplier.phoneNumber,
            'category': newSupplier.category,
            'rate': newSupplier.rate,
          }));
      _suppliers[supplierIndex] = newSupplier;
      notifyListeners();
    }
  }
}

class Supplier {
  final String id;
  final String name;
  final String location;
  final String image;
  final String email;
  final String password;
  final String phoneNumber;
  final String category;
  final double rate;

  Supplier(
      {required this.id,
      required this.name,
      required this.location,
      required this.image,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.category,
      required this.rate});
}
