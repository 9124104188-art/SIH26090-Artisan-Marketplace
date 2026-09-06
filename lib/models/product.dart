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
  });
}
