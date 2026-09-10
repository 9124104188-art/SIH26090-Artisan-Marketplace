import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../models/product.dart';

class AiApiException implements Exception {
  final String message;

  const AiApiException(this.message);

  @override
  String toString() => message;
}

class CatalogSuggestion {
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final String craftType;
  final List<String> materials;
  final int? price;
  final int? quantity;
  final double? confidence;

  const CatalogSuggestion({
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.craftType,
    required this.materials,
    this.price,
    this.quantity,
    this.confidence,
  });

  factory CatalogSuggestion.fromJson(Map<String, dynamic> json) {
    return CatalogSuggestion(
      title: json['title'] as String,
      description: json['description'] as String,
      category: _normalizeCategory(json['category'] as String),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      craftType: json['craftType'] as String? ?? 'Traditional Handicraft',
      materials:
          (json['materials'] as List<dynamic>? ?? const []).cast<String>(),
      price: (json['price'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      confidence: (json['confidence'] as num?)?.toDouble(),
    );
  }
}

String _normalizeCategory(String category) {
  switch (category.trim()) {
    case 'Handloom':
      return 'Textiles';
    case 'Woodcraft':
      return 'Wooden Crafts';
    case 'Basketry':
      return 'Bamboo Products';
    case 'Painting':
      return 'Paintings';
    case 'Other':
      return 'Handicrafts';
    default:
      return category;
  }
}

class ImageProcessResult {
  final String imageUrl;
  final int? width;
  final int? height;
  final bool enhanced;
  final bool backgroundRemoved;

  const ImageProcessResult({
    required this.imageUrl,
    this.width,
    this.height,
    required this.enhanced,
    required this.backgroundRemoved,
  });

  factory ImageProcessResult.fromJson(Map<String, dynamic> json) {
    return ImageProcessResult(
      imageUrl: json['imageUrl'] as String,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      enhanced: json['enhanced'] as bool? ?? false,
      backgroundRemoved: json['bgRemoved'] as bool? ?? false,
    );
  }
}

class PricingSuggestion {
  final int suggestedPrice;
  final int minimumPrice;
  final int maximumPrice;

  const PricingSuggestion({
    required this.suggestedPrice,
    required this.minimumPrice,
    required this.maximumPrice,
  });

  factory PricingSuggestion.fromJson(Map<String, dynamic> json) {
    return PricingSuggestion(
      suggestedPrice: (json['suggestedPrice'] as num).toInt(),
      minimumPrice: (json['minimumPrice'] as num).toInt(),
      maximumPrice: (json['maximumPrice'] as num).toInt(),
    );
  }
}

class RecommendationSuggestion {
  final String productId;
  final double score;
  final String reason;

  const RecommendationSuggestion({
    required this.productId,
    required this.score,
    required this.reason,
  });

  factory RecommendationSuggestion.fromJson(Map<String, dynamic> json) {
    return RecommendationSuggestion(
      productId: json['productId'] as String,
      score: (json['score'] as num).toDouble(),
      reason: json['reason'] as String,
    );
  }
}

class AiApiService {
  final http.Client _client;
  final String baseUrl;

  AiApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl =
            (baseUrl ?? ApiClient().baseUrl).replaceFirst(RegExp(r'/$'), '');

  Future<String> transcribeAudio({
    required Uint8List bytes,
    String filename = 'voice.wav',
  }) async {
    if (bytes.isEmpty) {
      throw const AiApiException('No voice recording was captured.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/ai/voice/transcribe'),
    )
      ..headers.addAll(ApiClient().authHeaders)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      ));

    try {
      final streamed =
          await _client.send(request).timeout(const Duration(seconds: 45));
      final response = await http.Response.fromStream(streamed);
      final body = _decodeBody(response);
      _throwIfFailure(response, body);
      final data = body['data'];
      final text = data is Map<String, dynamic> ? data['text'] : null;
      if (text is! String || text.trim().isEmpty) {
        throw const AiApiException(
            'The transcription service returned no text.');
      }
      return text.trim();
    } on AiApiException {
      rethrow;
    } on Exception {
      throw const AiApiException(
        'Unable to transcribe the recording. Check your connection and try again.',
      );
    }
  }

  Future<CatalogSuggestion> generateCatalog({
    required String text,
    String? category,
    String? imageUrl,
    String? artisanInfo,
  }) async {
    if (text.trim().isEmpty) {
      throw const AiApiException('Add a product description before analyzing.');
    }

    late http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('$baseUrl/api/ai/catalog/generate'),
            headers: {
              'Content-Type': 'application/json',
              ...ApiClient().authHeaders
            },
            body: jsonEncode({
              'text': text.trim(),
              if (category != null) 'category': category,
              if (imageUrl != null) 'imageUrl': imageUrl,
              if (artisanInfo != null) 'artisanInfo': artisanInfo,
            }),
          )
          .timeout(const Duration(seconds: 20));
    } on Exception {
      throw const AiApiException(
        'Unable to reach the AI service. Check that the FastAPI server is running.',
      );
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw const AiApiException(
          'The AI service returned an invalid response.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        body['success'] != true) {
      throw AiApiException(
        body['message'] as String? ??
            'The AI service could not generate a catalog.',
      );
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const AiApiException('The AI service returned no catalog data.');
    }

    try {
      return CatalogSuggestion.fromJson(data);
    } on TypeError {
      throw const AiApiException(
          'The AI service returned incomplete catalog data.');
    }
  }

  Future<ImageProcessResult> processImage({
    required Uint8List bytes,
    required String filename,
    bool removeBackground = true,
  }) async {
    if (bytes.isEmpty) {
      throw const AiApiException('The selected image is empty.');
    }
    if (bytes.length > 12 * 1024 * 1024) {
      throw const AiApiException('Please choose an image smaller than 12 MB.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/ai/image/process'),
    )
      ..headers.addAll(ApiClient().authHeaders)
      ..fields['removeBg'] = removeBackground.toString()
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      ));

    try {
      final streamed =
          await _client.send(request).timeout(const Duration(seconds: 180));
      final response = await http.Response.fromStream(streamed);
      final body = _decodeBody(response);
      _throwIfFailure(response, body);
      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        throw const AiApiException(
            'The AI service returned no processed image.');
      }
      final result = ImageProcessResult.fromJson(data);
      return ImageProcessResult(
        imageUrl: result.imageUrl.startsWith('/')
            ? '$baseUrl${result.imageUrl}'
            : result.imageUrl,
        width: result.width,
        height: result.height,
        enhanced: result.enhanced,
        backgroundRemoved: result.backgroundRemoved,
      );
    } on AiApiException {
      rethrow;
    } on Exception {
      throw const AiApiException(
        'Unable to upload the image. Check your connection and try again.',
      );
    }
  }

  Future<PricingSuggestion> predictPrice({
    required double materialCost,
    double labourHours = 0,
    double hourlyRate = 0,
    double overhead = 0,
    double marginPercent = 20,
    String craftComplexity = 'medium',
  }) async {
    late http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('$baseUrl/api/ai/pricing/predict'),
            headers: {
              'Content-Type': 'application/json',
              ...ApiClient().authHeaders
            },
            body: jsonEncode({
              'materialCost': materialCost,
              'labourHours': labourHours,
              'hourlyRate': hourlyRate,
              'overhead': overhead,
              'marginPercent': marginPercent,
              'craftComplexity': craftComplexity,
            }),
          )
          .timeout(const Duration(seconds: 20));
    } on Exception {
      throw const AiApiException('Unable to reach the pricing service.');
    }

    final body = _decodeBody(response);
    _throwIfFailure(response, body);
    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const AiApiException('The pricing service returned no suggestion.');
    }
    try {
      return PricingSuggestion.fromJson(data);
    } on TypeError {
      throw const AiApiException(
          'The pricing service returned incomplete data.');
    }
  }

  Future<List<RecommendationSuggestion>> recommendProducts({
    required List<Product> products,
    List<Product> preferenceProducts = const [],
    int limit = 8,
  }) async {
    if (products.isEmpty) return const [];

    final categories =
        preferenceProducts.map((product) => product.category).toSet();
    final tags = preferenceProducts
        .expand((product) => [...product.tags, ...product.materials])
        .toSet();
    final payload = {
      'products': products
          .map((product) => {
                'productId': product.apiId ?? product.id.toString(),
                'category': product.category,
                'tags': product.tags,
                'materials': product.materials,
                'price': product.price,
                'rating': product.rating,
                'reviews': product.reviews,
                'description': product.description,
              })
          .toList(),
      'preferredCategories': categories.toList(),
      'preferredTags': tags.toList(),
      'limit': limit,
    };

    late http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse('$baseUrl/api/ai/recommendations'),
            headers: {
              'Content-Type': 'application/json',
              ...ApiClient().authHeaders,
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 20));
    } on Exception {
      throw const AiApiException(
          'Unable to reach the recommendations service.');
    }

    final body = _decodeBody(response);
    _throwIfFailure(response, body);
    final data = body['data'];
    if (data is! Map<String, dynamic> || data['recommendations'] is! List) {
      throw const AiApiException(
          'The recommendations service returned no suggestions.');
    }
    try {
      return (data['recommendations'] as List<dynamic>)
          .map((item) =>
              RecommendationSuggestion.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TypeError {
      throw const AiApiException(
          'The recommendations service returned incomplete data.');
    }
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw const AiApiException(
          'The AI service returned an invalid response.');
    }
  }

  void _throwIfFailure(http.Response response, Map<String, dynamic> body) {
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        body['success'] != true) {
      throw AiApiException(body['message'] as String? ??
          'The AI service could not complete the request.');
    }
  }

  void dispose() => _client.close();
}
