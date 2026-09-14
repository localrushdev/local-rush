import 'package:flutter/material.dart';

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();
  CartService._internal();

  final Map<String, int> _items = {};
  final Map<String, Map<String, dynamic>> _products = {};

  Map<String, int> get items => _items;

  void add(Map<String, dynamic> product) {
    final name = product['name'];
    _products[name] = product;
    _items[name] = (_items[name] ?? 0) + 1;
    notifyListeners();
  }

  void remove(String name) {
    if (!_items.containsKey(name)) return;

    if (_items[name] == 1) {
      _items.remove(name);
      _products.remove(name);
    } else {
      _items[name] = _items[name]! - 1;
    }

    notifyListeners();
  }

  int quantity(String name) => _items[name] ?? 0;

  List<Map<String, dynamic>> get menuItems => _products.values.toList();

  int get totalItems => _items.values.fold(0, (sum, qty) => sum + qty);

  int get subtotal {
    int total = 0;

    for (final product in _products.values) {
      final qty = _items[product['name']] ?? 0;
      total += (product['price'] as int) * qty;
    }

    return total;
  }

  void clear() {
    _items.clear();
    _products.clear();
    notifyListeners();
  }
}
