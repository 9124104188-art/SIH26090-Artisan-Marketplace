import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'product_image.dart';
import 'price_rating.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final bool dense;

  const ProductCard(
      {super.key,
      required this.product,
      required this.onTap,
      required this.onAdd,
      this.dense = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border)),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ProductImage(
                  url: product.imageUrl,
                  width: double.infinity,
                  height: dense ? 110 : 135),
              Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .9),
                          shape: BoxShape.circle),
                      child:
                          const Icon(Icons.favorite_border_rounded, size: 18))),
            ]),
            const SizedBox(height: 8),
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13.5)),
            const SizedBox(height: 2),
            Text('By ${product.artisan}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            const SizedBox(height: 5),
            PriceRating(
                price: product.price, rating: product.rating, compact: dense),
            if (!dense) ...[
              const SizedBox(height: 7),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: onAdd,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 34),
                          padding: EdgeInsets.zero,
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white),
                      child: const Text('Add to Cart',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)))),
            ],
          ],
        ),
      ),
    );
  }
}
