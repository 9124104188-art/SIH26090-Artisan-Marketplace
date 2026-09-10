import 'api_client.dart';

class ProductService {
  final ApiClient _api = ApiClient();

  /// Fetch published products. Optional filters: category, search text.
  Future<List<Map<String, dynamic>>> getProducts({
    String? category,
    String? search,
    String status = 'published',
    int limit = 50,
  }) async {
    final params = <String, String>{'status': status, 'limit': '$limit'};
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final query = Uri(queryParameters: params).query;
    final data = await _api.getList('/api/products?$query');
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Fetch a single product by Mongo _id.
  Future<Map<String, dynamic>> getProduct(String id) async {
    return _api.get('/api/products/$id');
  }

  /// Create a new product (artisan only).
  Future<Map<String, dynamic>> createProduct({
    required String title,
    required String description,
    required String category,
    required double price,
    List<String>? materials,
    List<String>? tags,
    int stock = 12,
    List<String>? images,
    String status = 'published',
  }) async {
    return _api.post('/api/products', {
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'materials': materials ?? [],
      'tags': tags ?? [],
      'stock': stock,
      'images': images ?? [],
      'status': status,
    });
  }

  /// Update an existing product (artisan owner only).
  Future<Map<String, dynamic>> updateProduct(
          String id, Map<String, dynamic> fields) =>
      _api.put('/api/products/$id', fields);

  /// Delete a product (artisan owner only).
  Future<void> deleteProduct(String id) => _api.delete('/api/products/$id');
}
