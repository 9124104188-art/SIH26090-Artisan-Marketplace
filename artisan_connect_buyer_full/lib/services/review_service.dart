import 'api_client.dart';

class ReviewService {
  final ApiClient _api = ApiClient();

  Future<List<Map<String, dynamic>>> getReviews(String productId) async {
    final data = await _api.getList(
      '/api/reviews?productId=${Uri.encodeQueryComponent(productId)}',
    );
    if (data is List) return data.cast<Map<String, dynamic>>();
    return [];
  }

  Future<Map<String, dynamic>> createReview({
    required String productId,
    required int rating,
    String comment = '',
  }) {
    return _api.post('/api/reviews', {
      'productId': productId,
      'rating': rating,
      'comment': comment,
    });
  }
}
