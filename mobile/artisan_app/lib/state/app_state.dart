import 'package:flutter/material.dart';
import '../models/product.dart';
import '../l10n/app_translations.dart';

/// Which "page" is currently shown. This mirrors the original prototype's
/// single-page-app pattern (`showPage('someId')` swapping visible sections)
/// rather than a traditional push/pop navigation stack, so behavior stays
/// as close as possible to the source.
enum AppPage {
  login,
  register,
  home,
  addProduct,
  camera,
  voice,
  aiResults,
  pricing,
  editPublish,
  myProducts,
  orders,
  profile,
}

class AppState extends ChangeNotifier {
  AppPage currentPage = AppPage.login;

  // ---------------- Language ----------------
  String currentLanguage = 'en';

  String t(String key) => AppTranslations.t(currentLanguage, key);

  void setLanguage(String lang) {
    currentLanguage = lang;
    notifyListeners();
  }

  // ---------------- Auth (in-memory demo store, no backend) ----------------
  // REAL API INTEGRATION POINT: replace this map and the login/register
  // methods below with calls to a real authentication API.
  final Map<String, Map<String, String>> _registeredUsers = {
    'demo@artisanai.com': {'password': 'demo1234', 'name': 'Meena'},
  };

  String currentUserName = 'Artisan';
  String currentUserEmail = '';

  /// Returns null on success, or an error message key to show the user.
  String? login(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    if (normalizedEmail.isEmpty || trimmedPassword.isEmpty) {
      return t('err_fill_login');
    }

    final account = _registeredUsers[normalizedEmail];
    if (account == null) {
      return t('err_no_account');
    }
    if (account['password'] != trimmedPassword) {
      return t('err_wrong_password');
    }

    currentUserName = account['name'] ?? 'Artisan';
    currentUserEmail = normalizedEmail;
    currentPage = AppPage.home;
    notifyListeners();
    return null;
  }

  String? register(String name, String email, String password) {
    final trimmedName = name.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    if (trimmedName.isEmpty || normalizedEmail.isEmpty || trimmedPassword.isEmpty) {
      return t('err_fill_register');
    }
    if (_registeredUsers.containsKey(normalizedEmail)) {
      return t('err_account_exists');
    }

    _registeredUsers[normalizedEmail] = {
      'password': trimmedPassword,
      'name': trimmedName,
    };
    currentUserName = trimmedName;
    currentUserEmail = normalizedEmail;
    currentPage = AppPage.home;
    notifyListeners();
    return null;
  }

  void logout() {
    currentUserName = 'Artisan';
    currentUserEmail = '';
    currentPage = AppPage.login;
    notifyListeners();
  }

  // ---------------- Products (in-memory demo store, no backend) ----------------
  // REAL API INTEGRATION POINT: replace this seed list and the methods below
  // with calls to a real Product API.
  final List<Product> products = [
    Product(
      id: 1,
      name: 'Handmade Cotton Saree',
      description:
          'A beautifully handcrafted cotton saree created using traditional artisan techniques.',
      category: 'Clothing',
      price: 1499,
      status: 'published',
    ),
    Product(
      id: 2,
      name: 'Hand-carved Wooden Bowl',
      description: 'A rustic hand-carved wooden bowl, perfect for everyday use.',
      category: 'Home Decor',
      price: 900,
      status: 'draft',
    ),
  ];

  int _nextProductId = 3;
  int? editingProductId;

  int get publishedCount => products.length;

  double get totalEarned => products
      .where((p) => p.status == 'published')
      .fold(0.0, (sum, p) => sum + p.price);

  void removeProduct(int id) {
    products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Product? findProduct(int id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  // ---------------- In-progress "Add Product" draft ----------------
  // Mirrors the loose global variables used in the JS version
  // (currentProductPhoto, productName field, productDescription field, etc.)
  String draftName = '';
  String draftDescription = '';
  String? draftPhotoPath;
  String voiceTranscript = '';
  bool isRecording = false;

  void startNewProduct() {
    editingProductId = null;
    draftName = '';
    draftDescription = '';
    draftPhotoPath = null;
    voiceTranscript = '';
    currentPage = AppPage.addProduct;
    notifyListeners();
  }

  void openEditProduct(int id) {
    final p = findProduct(id);
    if (p == null) return;
    editingProductId = id;
    draftName = p.name;
    draftDescription = p.description;
    draftPhotoPath = p.photoPath;
    currentPage = AppPage.editPublish;
    notifyListeners();
  }

  void setDraftPhoto(String? path) {
    draftPhotoPath = path;
    notifyListeners();
  }

  void setVoiceTranscript(String text) {
    voiceTranscript = text;
    notifyListeners();
  }

  /// REAL API INTEGRATION POINT: this simulates AI/pricing/publish work with
  /// a short delay, exactly like the original prototype's setTimeout-based
  /// stubs. Replace the delay with real network calls when APIs are ready.
  Future<void> publishProduct({
    required String name,
    required String description,
    required String category,
    required double price,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (editingProductId != null) {
      final p = findProduct(editingProductId!);
      if (p != null) {
        p.name = name;
        p.description = description;
        p.category = category;
        p.price = price;
        p.status = 'published';
        p.photoPath = draftPhotoPath;
      }
    } else {
      products.insert(
        0,
        Product(
          id: _nextProductId++,
          name: name,
          description: description,
          category: category,
          price: price,
          status: 'published',
          photoPath: draftPhotoPath,
        ),
      );
    }

    editingProductId = null;
    currentPage = AppPage.myProducts;
    notifyListeners();
  }

  // ---------------- Navigation ----------------
  void goTo(AppPage page) {
    currentPage = page;
    notifyListeners();
  }
}
