import 'api_client.dart';

class OrderService {
  final ApiClient _api = ApiClient();

  /// Get orders for the current user (buyer sees own orders, artisan sees orders with their items).
  Future<List<Map<String, dynamic>>> getOrders() async {
    final data = await _api.getList('/api/orders');
    if (data is List) return data.cast<Map<String, dynamic>>();
    return [];
  }

  /// Create a new order.
  /// [items] is a list of { productId, quantity } maps.
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
  }) async {
    return _api.post('/api/orders', {'items': items});
  }
}
