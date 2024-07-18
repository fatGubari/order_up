// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final String supplier;
  final int quantity;
  final double price;
  final String amountType;
  final String image;

  CartItem( 
      {required this.id,
      required this.title,
      required this.supplier,
      required this.quantity,
      required this.price,
      required this.amountType,
      required this.image});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount{
    var total = 0.0;
    _items.forEach((key, value) => total += value.price * value.quantity,);
    return total;
  }

  void addItem(String productId, double price, String title, String image, String amount, String supplier) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              supplier: supplier,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price, 
              amountType: existingCartItem.amountType,
              image: existingCartItem.image));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                supplier: supplier,
                quantity: 1,
                price: price,
                amountType: amount,
                image: image,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}