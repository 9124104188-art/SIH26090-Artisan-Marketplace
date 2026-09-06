import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../controllers/artisan_controller.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import '../widgets/price_rating.dart';
import '../widgets/custom_button.dart';
import 'artisan_details_screen.dart';
import 'add_product_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final CartController cart;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.cart,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final isArtisan = ArtisanController().isArtisan;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to wishlist!')),
              );
            },
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product link copied to clipboard')),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          // Image Hero
          Hero(
            tag: 'p${widget.product.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ProductImage(
                url: widget.product.imageUrl,
                width: double.infinity,
                height: 320,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title & Stock Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.product.stock > 5 ? AppColors.primarySoft : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.product.stock > 5 ? AppColors.primary : AppColors.error,
                  ),
                ),
                child: Text(
                  'In Stock (${widget.product.stock})',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: widget.product.stock > 5 ? AppColors.primaryDark : AppColors.error,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Artisan Info Line
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArtisanDetailsScreen(
                  artisan: widget.product.artisan,
                  products: const [],
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront_outlined, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'By ${widget.product.artisan} • ${widget.product.city}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Price & Rating
          PriceRating(
            price: widget.product.price,
            rating: widget.product.rating,
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.product.reviews} customer reviews',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),

          const SizedBox(height: 16),

          const Text(
            'Product Story & Description',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            widget.product.description,
            style: const TextStyle(height: 1.5, color: AppColors.textPrimary, fontSize: 14),
          ),

          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.tags
                .map((t) => Chip(
                      label: Text(t),
                      backgroundColor: AppColors.primarySoft,
                    ))
                .toList(),
          ),

          const SizedBox(height: 18),

          // Trust Badge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_rounded, color: AppColors.primary, size: 26),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direct Artisan Support Guarantee',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '100% authentic local handicraft. Fair pricing goes directly to the creator.',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          if (isArtisan) ...[
            CustomButton(
              label: 'Edit Product Catalog',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductScreen(initialProduct: widget.product),
                  ),
                );
              },
              icon: Icons.edit_note_rounded,
              type: ButtonType.secondary,
            ),
          ] else ...[
            Row(
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                        icon: const Icon(Icons.remove, size: 18),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                      Text(
                        '$qty',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () => setState(() => qty++),
                        icon: const Icon(Icons.add, size: 18),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Add to Cart',
                    onPressed: () {
                      widget.cart.add(widget.product, qty);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    type: ButtonType.outline,
                    icon: Icons.add_shopping_cart_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: 'Buy Now',
                    onPressed: () {
                      widget.cart.add(widget.product, qty);
                      Navigator.pop(context);
                    },
                    type: ButtonType.primary,
                    icon: Icons.flash_on_rounded,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
