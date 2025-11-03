// lib/features/order_history/data/order_provider.dart
import 'package:flutter/material.dart';
import 'package:food_app/features/order_history/data/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(Order order) {
    _orders.insert(0, order); // Add new orders at the beginning
    notifyListeners();
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}