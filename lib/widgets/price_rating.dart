import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PriceRating extends StatelessWidget {
  final int price;
  final double rating;
  final bool compact;
  const PriceRating({super.key, required this.price, required this.rating, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('₹$price', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.green, fontSize: compact ? 14 : 16)),
        const Spacer(),
        const Icon(Icons.star_rounded, size: 16, color: AppColors.gold),
        const SizedBox(width: 2),
        Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: compact ? 12 : 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
