import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:order_up/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrdersItem {
  final String id;
  final double amount;
  final String resturantName;
  final String resturantId;
  final List<CartItem> products;
  final DateTime dateTime;
  String status;

  OrdersItem({
    required this.id,
    required this.amount,
    required this.resturantName,
    required this.resturantId,
    required this.products,
    required this.dateTime,
    this.status = 'In Progress',
  });
}

class Orders with ChangeNotifier {
  List<OrdersItem> _orders = [];
  final String authToken;
  final String userId;
  final String userName;
  final String userType;

  Orders(
      this.authToken, this.userId, this.userName, this.userType, this._orders);

  List<OrdersItem> get orders {
    return [..._orders];
  }

  @override
  void dispose() {
    debugPrint('Orders provider disposed');
    super.dispose();
  }

  Future fetchAndSetOrders() async {
    final List<OrdersItem> loadedOrders = [];

    if (userType == 'restaurant') {
      final url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      if (extractedData != null) {
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(
            OrdersItem(
              id: orderId,
              amount: orderData['amount'] ?? 0.0,
              resturantName: orderData['resturantName'] ?? '',
              resturantId: userId, // Assign the restaurant's userId
              dateTime: DateTime.parse(orderData['dateTime']),
              status: orderData['status'] ?? '',
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                        id: item['id'],
                        title: item['title'],
                        supplier: item['supplier'],
                        quantity: item['quantity'],
                        price: item['price'] ?? 0.0,
                        amountType: item['amountType'] ?? '',
                        image: item['image'] ?? '',
                      ))
                  .toList(),
            ),
          );
        });
      }
      _orders = loadedOrders
          .where((order) => order.resturantName == userName)
          .toList();
    } else if (userType == 'supplier') {
      final url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      if (extractedData != null) {
        for (var restaurantId in extractedData.keys) {
          final restaurantOrders =
              extractedData[restaurantId] as Map<String, dynamic>;
          restaurantOrders.forEach((orderId, orderData) {
            loadedOrders.add(
              OrdersItem(
                id: orderId,
                amount: orderData['amount'] ?? 0.0,
                resturantName: orderData['resturantName'] ?? '',
                resturantId: restaurantId, // Assign the restaurantId
                dateTime: DateTime.parse(orderData['dateTime']),
                status: orderData['status'] ?? '',
                products: (orderData['products'] as List<dynamic>)
                    .map((item) => CartItem(
                          id: item['id'],
                          title: item['title'],
                          supplier: item['supplier'],
                          quantity: item['quantity'],
                          price: item['price'] ?? 0.0,
                          amountType: item['amountType'] ?? '',
                          image: item['image'] ?? '',
                        ))
                    .toList(),
              ),
            );
          });
        }
      }
      _orders = loadedOrders
          .where((order) =>
              order.products.any((product) => product.supplier == userName))
          .toList();
    }

    notifyListeners();
  }

  Future addOrder(List<CartItem> cartProducts, double total, String resturan,
      String restaurantId) async {
    final url =
        'https://order-up-e0a41-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'resturantName': resturan,
          'resturantId': restaurantId,
          'dateTime': timeStamp.toIso8601String(),
          'status': 'In Progress',
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'supplier': cartProduct.supplier,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                    'amountType': cartProduct.amountType,
                    'image': cartProduct.image,
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrdersItem(
          id: json.decode(response.body)['name'],
          amount: total,
          resturantName: resturan,
          resturantId: restaurantId,
          dateTime: DateTime.now(),
          products: cartProducts,
        ));
    notifyListeners();
  }

  Map<String, List<Map<String, dynamic>>> getSupplierAndAmount(
      OrdersItem order) {
    final Map<String, List<Map<String, dynamic>>> supplierAndAmount = {};

    for (var product in order.products) {
      final productInfo = {
        'title': product.title,
        'price': product.price,
        'amountType': product.amountType
      };

      if (supplierAndAmount.containsKey(product.supplier)) {
        supplierAndAmount[product.supplier]!.add(productInfo);
      } else {
        supplierAndAmount[product.supplier] = [productInfo];
      }
    }
    return supplierAndAmount;
  }

  Future confirmOrder(String orderId) async {
    OrdersItem? targetOrder;
    String? restaurantId;

    for (var order in _orders) {
      if (order.id == orderId) {
        targetOrder = order;
        restaurantId = order.resturantId;
        break;
      }
    }

    if (targetOrder != null && restaurantId != null) {
      final url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/orders/$restaurantId/$orderId.json?auth=$authToken';
      targetOrder.status = 'Completed';
      try {
        final response = await http.patch(
          Uri.parse(url),
          body: json.encode({
            'status': 'Completed',
          }),
        );
        if (response.statusCode >= 400) {
          throw HttpException('Could not update order.');
        }
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  bool areAllOrdersCompleted() {
    return _orders.isNotEmpty &&
        _orders.every((order) => order.status == 'Completed');
  }

  Future cancelOrder(String orderId) async {
    OrdersItem? targetOrder;
    String? restaurantId;

    for (var order in _orders) {
      if (order.id == orderId) {
        targetOrder = order;
        restaurantId = order.resturantId;
        break;
      }
    }

    if (targetOrder != null && restaurantId != null) {
      final url =
          'https://order-up-e0a41-default-rtdb.firebaseio.com/orders/$restaurantId/$orderId.json?auth=$authToken';
      try {
        final response = await http.delete(
          Uri.parse(url),
        );
        if (response.statusCode >= 400) {
          throw HttpException('Could not delete order.');
        }
        _orders.remove(targetOrder);
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  List<OrdersItem> get confirmedOrders {
    return _orders.where((order) => order.status == 'Completed').toList();
  }
}
