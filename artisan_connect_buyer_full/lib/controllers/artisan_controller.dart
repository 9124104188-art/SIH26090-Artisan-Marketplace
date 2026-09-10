import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_client.dart';
import '../services/product_service.dart';

class ArtisanController extends ChangeNotifier {
  static final ArtisanController _instance = ArtisanController._internal();
  factory ArtisanController() => _instance;
  ArtisanController._internal();

  String _userRole = 'artisan'; // 'artisan' or 'buyer'
  String _artisanName = 'Ramesh Crafts';
  String _artisanCategory = 'Handicrafts & Pottery';
  String _artisanCity = 'Thanjavur, Tamil Nadu';

  List<Product> _products = [];
  final ProductService _productService = ProductService();
  bool _isLoadingProducts = false;
  String? _productError;

  String get userRole => _userRole;
  bool get isArtisan => _userRole == 'artisan';
  String get artisanName => _artisanName;
  String get artisanCategory => _artisanCategory;
  String get artisanCity => _artisanCity;

  List<Product> get allProducts => List.unmodifiable(_products);
  bool get isLoadingProducts => _isLoadingProducts;
  String? get productError => _productError;

  List<Product> get myArtisanProducts => _products;

  int get myProductCount => myArtisanProducts.length;
  int get activeOrdersCount => 18;
  int get totalSalesAmount => 42850;

  void switchRole(String role) {
    final authenticatedRole = ApiClient().currentUser?['role'] as String?;
    if (authenticatedRole != role) return;
    _userRole = role;
    notifyListeners();
  }

  Future<void> loadProducts({String? category, String? search}) async {
    _isLoadingProducts = true;
    _productError = null;
    notifyListeners();
    try {
      final data = await _productService.getProducts(
        category: category,
        search: search,
      );
      _products = data.map(Product.fromApi).toList();
    } on ApiException catch (error) {
      _productError = error.message;
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  void updateArtisanProfile({String? name, String? category, String? city}) {
    if (name != null) _artisanName = name;
    if (category != null) _artisanCategory = category;
    if (city != null) _artisanCity = city;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final data = await _productService.createProduct(
      title: product.name,
      description: product.description,
      category: product.category,
      price: product.price.toDouble(),
      materials: product.materials,
      tags: product.tags,
      stock: product.stock,
      images: product.imageUrl.isEmpty ? [] : [product.imageUrl],
    );
    _products.insert(0, Product.fromApi(data));
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    if (updatedProduct.apiId == null) {
      throw const ApiException('This product is not linked to the server.');
    }
    final data = await _productService.updateProduct(updatedProduct.apiId!, {
      'title': updatedProduct.name,
      'description': updatedProduct.description,
      'category': updatedProduct.category,
      'price': updatedProduct.price,
      'materials': updatedProduct.materials,
      'tags': updatedProduct.tags,
      'stock': updatedProduct.stock,
      'images':
          updatedProduct.imageUrl.isEmpty ? [] : [updatedProduct.imageUrl],
    });
    final updated = Product.fromApi(data);
    final index = _products.indexWhere((p) => p.apiId == updatedProduct.apiId);
    if (index != -1) _products[index] = updated;
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    if (product.apiId == null) {
      throw const ApiException('This product is not linked to the server.');
    }
    await _productService.deleteProduct(product.apiId!);
    _products.removeWhere((p) => p.apiId == product.apiId);
    notifyListeners();
  }
}
