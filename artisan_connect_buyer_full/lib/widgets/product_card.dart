import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'product_image.dart';
import 'price_rating.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool dense;
  final bool isArtisanView;
  final double aspectRatio;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
    this.onEdit,
    this.onDelete,
    this.dense = false,
    this.isArtisanView = false,
    this.aspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(
                    url: product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (!isArtisanView)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  else
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: product.stock > 5
                              ? AppColors.primarySoft
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: product.stock > 5
                                ? AppColors.primary
                                : AppColors.error,
                          ),
                        ),
                        child: Text(
                          'Stock: ${product.stock}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: product.stock > 5
                                ? AppColors.primaryDark
                                : AppColors.error,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isArtisanView ? product.category : 'By ${product.artisan}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 6),
            PriceRating(
              price: product.price,
              rating: product.rating,
              compact: dense,
            ),
            if (!dense) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: isArtisanView
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit_outlined, size: 14),
                              label: const Text('Edit Catalog',
                                  style: TextStyle(fontSize: 11)),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 32),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (onDelete != null) ...[
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: onDelete,
                              tooltip: 'Delete product',
                              icon: const Icon(Icons.delete_outline_rounded),
                              color: AppColors.error,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 32, minHeight: 32),
                            ),
                          ],
                        ],
                      )
                    : ElevatedButton(
                        onPressed: onAdd,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 34),
                          padding: EdgeInsets.zero,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
