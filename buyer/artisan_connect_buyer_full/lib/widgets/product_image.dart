import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const ProductImage({super.key, required this.url, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius = const BorderRadius.all(Radius.circular(12))});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFFF0F4F2),
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, color: Color(0xFF8A9790), size: 36),
        ),
        loadingBuilder: (context, child, progress) => progress == null ? child : Container(
          width: width,
          height: height,
          color: const Color(0xFFF4F7F5),
          alignment: Alignment.center,
          child: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}
