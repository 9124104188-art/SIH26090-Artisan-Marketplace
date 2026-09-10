import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../controllers/artisan_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/section_title.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<Product> onProduct;
  final CartController cart;

  const HomeScreen({
    super.key,
    required this.onProduct,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final artisanController = ArtisanController();

    return AnimatedBuilder(
      animation: artisanController,
      builder: (context, _) {
        final products = artisanController.allProducts;
        final featured = products.take(8).toList();

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              // Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'SIH26090 • Direct Market Linkage',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Discover Authentic Handicrafts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shop directly from rural Indian artisans. 100% fair price guaranteed.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Categories Header
              const SectionTitle(
                title: 'Craft Categories',
                subtitle: 'Explore authentic handloom & artisanal traditions',
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 116,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (c, i) {
                    final cat = categories[i];
                    return SizedBox(
                      width: 88,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryScreen(
                              onProduct: onProduct,
                              cart: cart,
                              initialCategory: cat.name,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    cat.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(color: AppColors.primarySoft),
                                  ),
                                  Container(
                                      color:
                                          Colors.black.withValues(alpha: 0.2)),
                                  Center(
                                    child: Icon(cat.icon,
                                        size: 28, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              // Featured Products Header
              SectionTitle(
                title: 'Featured Artisan Creations',
                subtitle: 'Handpicked items with verified craft origins',
                actionLabel: 'View All',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CategoryScreen(onProduct: onProduct, cart: cart),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featured.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900
                      ? 4
                      : (MediaQuery.of(context).size.width > 600 ? 3 : 2),
                  childAspectRatio:
                      MediaQuery.of(context).size.width > 600 ? 0.78 : 0.67,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (c, i) => ProductCard(
                  product: featured[i],
                  aspectRatio: 1.2,
                  onTap: () => onProduct(featured[i]),
                  onAdd: () {
                    cart.add(featured[i]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${featured[i].name} added to cart'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
