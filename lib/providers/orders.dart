import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leles_shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:leles_shop/providers/product.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.parse('https://leles-7bcf1.firebaseio.com/orders.json');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse('https://leles-7bcf1.firebaseio.com/orders.json');
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quantity'],
                    title: e['title'],
                  ),
                )
                .toList()));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {}
  }
}
