// lib/features/cart/data/cart_provider.dart
import 'package:flutter/material.dart';
import 'package:food_app/features/cart/data/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get total {
    double sum = 0.0;
    for (var item in _items) {
      sum += item.unitPrice * item.quantity;
    }
    return sum;
  }

  void addItem(CartItem newItem) {
    int index = _items.indexWhere((item) => item.id == newItem.id);

    if (index >= 0) {
      _items[index].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}