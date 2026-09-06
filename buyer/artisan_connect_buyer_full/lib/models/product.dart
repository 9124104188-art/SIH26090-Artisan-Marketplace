class Product {
  final int id;
  final String name;
  final String category;
  final String artisan;
  final String city;
  final int price;
  final double rating;
  final int reviews;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final bool featured;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.artisan,
    required this.city,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.imageUrl,
    required this.tags,
    this.featured = false,
    this.stock = 12,
  });

  Product copyWith({
    int? id,
    String? name,
    String? category,
    String? artisan,
    String? city,
    int? price,
    double? rating,
    int? reviews,
    String? description,
    String? imageUrl,
    List<String>? tags,
    bool? featured,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      artisan: artisan ?? this.artisan,
      city: city ?? this.city,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      featured: featured ?? this.featured,
      stock: stock ?? this.stock,
    );
  }
}
