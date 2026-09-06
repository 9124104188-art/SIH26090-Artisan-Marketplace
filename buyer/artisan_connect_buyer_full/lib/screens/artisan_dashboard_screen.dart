import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../controllers/artisan_controller.dart';
import '../models/product.dart';
import '../widgets/section_title.dart';
import '../widgets/product_card.dart';
import '../widgets/empty_state.dart';
import '../controllers/cart_controller.dart';
import 'add_product_screen.dart';
import 'ai_cataloging_screen.dart';
import 'product_details_screen.dart';

class ArtisanDashboardScreen extends StatefulWidget {
  final CartController cart;
  final Function(Product)? onProductTap;

  const ArtisanDashboardScreen({
    super.key,
    required this.cart,
    this.onProductTap,
  });

  @override
  State<ArtisanDashboardScreen> createState() => _ArtisanDashboardScreenState();
}

class _ArtisanDashboardScreenState extends State<ArtisanDashboardScreen> {
  final _artisanController = ArtisanController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _artisanController,
      builder: (context, _) {
        final products = _artisanController.myArtisanProducts;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              // Welcome Artisan Header Card
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
                      color: AppColors.primary.withValues(alpha: 0.2),
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
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Welcome, ${_artisanController.artisanName}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified_rounded, color: AppColors.accent, size: 18),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_artisanController.artisanCategory} • ${_artisanController.artisanCity}',
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
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: AppColors.accent, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'AI Smart Cataloging ready! Add products with automated AI description & price tagging.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Metrics Row
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'Your Products',
                      value: '${_artisanController.myProductCount}',
                      color: AppColors.primary,
                      bgColor: AppColors.primarySoft,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Active Orders',
                      value: '${_artisanController.activeOrdersCount}',
                      color: AppColors.secondary,
                      bgColor: AppColors.secondarySoft,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.currency_rupee_rounded,
                      title: 'Total Sales',
                      value: '₹${_artisanController.totalSalesAmount}',
                      color: AppColors.accent,
                      bgColor: const Color(0xFFFFF8E1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Quick Actions
              const SectionTitle(
                title: 'Quick Actions',
                subtitle: 'Manage inventory & generate AI smart cataloging',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      label: 'Add Product',
                      icon: Icons.add_circle_outline_rounded,
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddProductScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionButton(
                      context: context,
                      label: 'AI Smart Catalog',
                      icon: Icons.auto_awesome_rounded,
                      color: AppColors.secondary,
                      isSpecial: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AICatalogingScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Your Products List Header
              SectionTitle(
                title: 'Your Products Catalog',
                subtitle: 'Manage, edit & check stock levels',
                actionLabel: 'View All',
                onAction: () {},
              ),
              const SizedBox(height: 12),

              if (products.isEmpty)
                EmptyState(
                  icon: Icons.add_business_rounded,
                  title: 'No products listed yet',
                  description: 'Start selling by adding your first handcrafted item using AI Smart Cataloging.',
                  buttonLabel: 'Add Product',
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddProductScreen()),
                    );
                  },
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length > 6 ? 6 : products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 900
                        ? 4
                        : (MediaQuery.of(context).size.width > 600 ? 3 : 2),
                    childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.78 : 0.67,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    final product = products[i];
                    return ProductCard(
                      product: product,
                      isArtisanView: true,
                      aspectRatio: 1.2,
                      onTap: () {
                        if (widget.onProductTap != null) {
                          widget.onProductTap!(product);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                product: product,
                                cart: widget.cart,
                              ),
                            ),
                          );
                        }
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddProductScreen(initialProduct: product),
                          ),
                        );
                      },
                      onAdd: () {},
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSpecial ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isSpecial ? null : Border.all(color: AppColors.border),
          boxShadow: isSpecial
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSpecial ? Colors.white : color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
                color: isSpecial ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
