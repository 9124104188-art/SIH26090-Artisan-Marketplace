import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../controllers/artisan_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_state.dart';
import '../theme/app_theme.dart';

class ProductListingScreen extends StatefulWidget {
  final String? category;
  final ValueChanged<Product> onProduct;
  final CartController cart;

  const ProductListingScreen({
    super.key,
    required this.category,
    required this.onProduct,
    required this.cart,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _artisanController = ArtisanController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _artisanController,
      builder: (context, _) {
        final all = _artisanController.allProducts;
        final products = all
            .where((p) => widget.category == null || p.category == widget.category)
            .toList();

        final imageUrl = categoryImageFor(widget.category);

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.category != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: AppColors.primarySoft),
                            ),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.6),
                                    Colors.black.withValues(alpha: 0.2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.category!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  '${products.length} Authentic Craft Products',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Text(
                    widget.category ?? 'All Marketplace Products',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                Expanded(
                  child: products.isEmpty
                      ? const EmptyState(
                          title: 'No products in this category',
                          description: 'Check back soon for new artisan handcrafted additions.',
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                          itemCount: products.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width > 900
                                ? 4
                                : (MediaQuery.of(context).size.width > 600 ? 3 : 2),
                            childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.78 : 0.67,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (_, index) {
                            final p = products[index];
                            return ProductCard(
                              product: p,
                              aspectRatio: 1.2,
                              onTap: () => widget.onProduct(p),
                              onAdd: () {
                                widget.cart.add(p);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${p.name} added to cart'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
