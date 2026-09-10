class Product {
  final int id;
  final String? apiId;
  final String name;
  final String category;
  final String artisan;
  final String city;
  final int price;
  final double rating;
  final int reviews;
  final String description;
  final String imageUrl;
  final List<String> materials;
  final List<String> tags;
  final bool featured;
  final int stock;

  const Product({
    required this.id,
    this.apiId,
    required this.name,
    required this.category,
    required this.artisan,
    required this.city,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.imageUrl,
    this.materials = const [],
    required this.tags,
    this.featured = false,
    this.stock = 12,
  });

  factory Product.fromApi(Map<String, dynamic> data) {
    final rawId = data['_id']?.toString() ?? data['id']?.toString() ?? '';
    final artisanData = data['artisanId'];
    final artisan = artisanData is Map<String, dynamic> ? artisanData : null;
    final userData = artisan?['userId'];
    final user = userData is Map<String, dynamic> ? userData : null;
    final images = data['images'];
    final materials = data['materials'];
    final tags = data['tags'];

    return Product(
      id: rawId.hashCode,
      apiId: rawId.isEmpty ? null : rawId,
      name: data['title']?.toString() ?? 'Untitled Product',
      category: data['category']?.toString() ?? 'Other',
      artisan: user?['name']?.toString() ?? 'Artisan',
      city: artisan?['location']?.toString() ?? '',
      price: (data['price'] as num?)?.round() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviews: (data['reviewCount'] as num?)?.toInt() ?? 0,
      description: data['description']?.toString() ?? '',
      imageUrl:
          images is List && images.isNotEmpty ? images.first.toString() : '',
      materials: materials is List
          ? materials.map((item) => item.toString()).toList()
          : const [],
      tags: tags is List
          ? tags.map((item) => item.toString()).toList()
          : const [],
      featured: false,
      stock: (data['stock'] as num?)?.toInt() ?? 12,
    );
  }

  Product copyWith({
    int? id,
    String? apiId,
    String? name,
    String? category,
    String? artisan,
    String? city,
    int? price,
    double? rating,
    int? reviews,
    String? description,
    String? imageUrl,
    List<String>? materials,
    List<String>? tags,
    bool? featured,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      name: name ?? this.name,
      category: category ?? this.category,
      artisan: artisan ?? this.artisan,
      city: city ?? this.city,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      materials: materials ?? this.materials,
      tags: tags ?? this.tags,
      featured: featured ?? this.featured,
      stock: stock ?? this.stock,
    );
  }
}
