import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  final String? category; final ValueChanged<Product> onProduct; final CartController cart;
  const ProductListingScreen({super.key, required this.category, required this.onProduct, required this.cart});
  @override State<ProductListingScreen> createState() => _ProductListingScreenState();
}
class _ProductListingScreenState extends State<ProductListingScreen> {
  late final List<Product> products = buildProducts().where((p) => widget.category == null || p.category == widget.category).toList();
  @override Widget build(BuildContext context) {
    final imageUrl = categoryImageFor(widget.category);
    return Column(
      children: [
        if (widget.category != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.black.withValues(alpha: .45), Colors.black.withValues(alpha: .15)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    bottom: 16,
                    child: Text(
                      widget.category!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Text(widget.category ?? 'All Products', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .65),
            itemBuilder: (_, index) => ProductCard(product: products[index], onTap: () => widget.onProduct(products[index]), onAdd: () => widget.cart.add(products[index])),
          ),
        ),
      ],
    );
  }
}
