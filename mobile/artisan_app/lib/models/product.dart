/// Mirrors the plain JS product object from the original prototype:
/// { id, name, description, category, price, status, photo }
class Product {
  final int id;
  String name;
  String description;
  String category;
  double price;
  String status; // 'published' | 'draft' | 'outofstock'
  String? photoPath;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    this.photoPath,
  });
}
