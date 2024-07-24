import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> products = [];
  late final String authToken;
  late final String userId;
  bool _authIsSet = false;

  void setAuth(String authToken, String userId, List<Product> products) {
    if (_authIsSet) return;

    this.authToken = authToken;
    this.userId = userId;
    this.products = products;

    _authIsSet = true;
  }

  List<Product> get productsData {
    return [...products];
  }

  Product findById(String id) {
    return products.firstWhere((prod) => prod.id == id);
  }

  Future fetchAndSetProducts() async {
    final url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        // print('No data found');
        return;
      }

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          supplier: prodData['supplier'],
          category: prodData['category'],
          amount: List<String>.from(prodData['amount']),
          description: prodData['description'],
          image: List<String>.from(prodData['image']),
          price: List<String>.from(prodData['price']),
        ));
      });
      print(
          '---------------------------------------------------------------$loadedProducts');

      products = loadedProducts;
      notifyListeners();
    } catch (error) {
      // print('Error fetching products: $error');
      rethrow;
    }
  }

  Future fetchAndSetProductsForRestaurant() async {
    const url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/products.json?';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        // print('No data found');
        return;
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          supplier: prodData['supplier'],
          category: prodData['category'],
          amount: List<String>.from(prodData['amount']),
          description: prodData['description'],
          image: List<String>.from(prodData['image']),
          price: List<String>.from(prodData['price']),
        ));
      });

      products = loadedProducts;
      notifyListeners();
    } catch (error) {
      // print('Error fetching products: $error');
      rethrow;
    }
  }

  Future addProduct(Product product) async {
    final url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'supplier': product.supplier,
            'category': product.category,
            'amount': product.amount,
            'description': product.description,
            'image': product.image,
            'price': product.price,
            'creatorId': userId
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        supplier: product.supplier,
        category: product.category,
        amount: product.amount,
        description: product.description,
        image: product.image,
        price: product.price,
      );
      products.add(newProduct);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future updateProduct(String id, Product newProduct) async {
    final prodIndex = products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'supplier': newProduct.supplier,
            'category': newProduct.category,
            'amount': newProduct.amount,
            'description': newProduct.description,
            'image': newProduct.image,
            'price': newProduct.price,
          }));
      products[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // ignore: avoid_print
      print('.....');
    }
  }

  Future deleteProduct(String id) async {
    final url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = products.indexWhere((prod) => prod.id == id);
    Product? existingProduct = products[existingProductIndex];
    products.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}

class Product {
  final String id;
  final String title;
  final String supplier;
  final String category;
  final List<String> amount;
  final String description;
  final List<String> image;
  final List<String> price;

  Product({
    required this.id,
    required this.title,
    required this.supplier,
    required this.category,
    required this.amount,
    required this.description,
    required this.image,
    required this.price,
  });
}
