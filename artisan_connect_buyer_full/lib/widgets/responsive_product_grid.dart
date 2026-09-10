import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_card.dart';

class ResponsiveProductGrid extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product>? onEditProduct;
  final bool isArtisanView;
  final EdgeInsetsGeometry padding;

  const ResponsiveProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    this.onEditProduct,
    this.isArtisanView = false,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Fix 3: Responsive columns (2 on mobile, 3 on tablet, 4 on desktop/web)
        int crossAxisCount;
        double childAspectRatio;

        if (width < 600) {
          crossAxisCount = 2;
          childAspectRatio = 0.67; // Tightly fits card content on mobile
        } else if (width < 900) {
          crossAxisCount = 3;
          childAspectRatio = 0.72;
        } else {
          crossAxisCount = 4;
          childAspectRatio = 0.76;
        }

        return GridView.builder(
          padding: padding,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              isArtisanView: isArtisanView,
              onTap: () => onProductTap(product),
              onAdd: () => onAddToCart(product),
              onEdit: onEditProduct != null ? () => onEditProduct!(product) : null,
            );
          },
        );
      },
    );
  }
}
