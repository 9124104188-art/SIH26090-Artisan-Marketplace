import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../data/catalog.dart';

class ArtisanController extends ChangeNotifier {
  static final ArtisanController _instance = ArtisanController._internal();
  factory ArtisanController() => _instance;
  ArtisanController._internal() {
    _products = buildProducts();
  }

  String _userRole = 'artisan'; // 'artisan' or 'buyer'
  String _artisanName = 'Ramesh Crafts';
  String _artisanCategory = 'Handicrafts & Pottery';
  String _artisanCity = 'Thanjavur, Tamil Nadu';
  
  late List<Product> _products;

  String get userRole => _userRole;
  bool get isArtisan => _userRole == 'artisan';
  String get artisanName => _artisanName;
  String get artisanCategory => _artisanCategory;
  String get artisanCity => _artisanCity;

  List<Product> get allProducts => List.unmodifiable(_products);

  List<Product> get myArtisanProducts =>
      _products.where((p) => p.artisan.toLowerCase().contains('ramesh') || p.artisan == _artisanName).toList();

  int get myProductCount => myArtisanProducts.length;
  int get activeOrdersCount => 18;
  int get totalSalesAmount => 42850;

  void switchRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  void updateArtisanProfile({String? name, String? category, String? city}) {
    if (name != null) _artisanName = name;
    if (category != null) _artisanCategory = category;
    if (city != null) _artisanCity = city;
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(int id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
