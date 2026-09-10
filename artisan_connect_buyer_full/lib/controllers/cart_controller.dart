import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  final Map<int, int> _items = {};
  final Map<int, Product> _products = {};

  Map<int, int> get items => Map.unmodifiable(_items);
  List<Product> get products =>
      _items.keys.map((id) => _products[id]!).toList();

  int quantity(Product product) => _items[product.id] ?? 0;

  void add(Product product, [int qty = 1]) {
    _products[product.id] = product;
    _items[product.id] = quantity(product) + qty;
    notifyListeners();
  }

  void removeOne(Product product) {
    final q = quantity(product);
    if (q <= 1) {
      _items.remove(product.id);
      _products.remove(product.id);
    } else {
      _items[product.id] = q - 1;
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    _products.remove(product.id);
    notifyListeners();
  }

  int get itemCount => _items.values.fold(0, (a, b) => a + b);
  int get subtotal => _items.entries
      .fold(0, (sum, e) => sum + _products[e.key]!.price * e.value);
  int get shipping => subtotal == 0 || subtotal >= 1500 ? 0 : 80;
  int get total => subtotal + shipping;

  void clear() {
    _items.clear();
    _products.clear();
    notifyListeners();
  }
}
