import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import '../widgets/price_rating.dart';
import 'artisan_details_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final CartController cart;
  const ProductDetailsScreen(
      {super.key, required this.product, required this.cart});
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int qty = 1;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Product Details'), actions: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined))
      ]),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
          children: [
            Hero(
                tag: 'p${widget.product.id}',
                child: ProductImage(
                    url: widget.product.imageUrl,
                    width: double.infinity,
                    height: 330,
                    borderRadius: BorderRadius.circular(18))),
            const SizedBox(height: 14),
            Text(widget.product.name,
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ArtisanDetailsScreen(
                            artisan: widget.product.artisan,
                            products: const []))),
                child: Text(
                    'By ${widget.product.artisan} · ${widget.product.city}',
                    style: const TextStyle(color: AppColors.muted))),
            const SizedBox(height: 12),
            PriceRating(
                price: widget.product.price, rating: widget.product.rating),
            Text('${widget.product.reviews} reviews',
                style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            const SizedBox(height: 14),
            Text(widget.product.description,
                style: const TextStyle(height: 1.5, color: AppColors.muted)),
            const SizedBox(height: 14),
            Wrap(
                spacing: 8,
                children: widget.product.tags
                    .map((t) => Chip(
                        label: Text(t), backgroundColor: AppColors.softGreen))
                    .toList()),
            const SizedBox(height: 16),
            Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: AppColors.softGreen,
                    borderRadius: BorderRadius.circular(14)),
                child: const Row(children: [
                  Icon(Icons.verified_user_outlined, color: AppColors.green),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                          'Handmade • Supports local artisans • Quality checked',
                          style: TextStyle(fontWeight: FontWeight.w600)))
                ])),
            const SizedBox(height: 18),
            Row(children: [
              const Text('Quantity',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              IconButton(
                  onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
                  icon: const Icon(Icons.remove_circle_outline)),
              Text('$qty',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 18)),
              IconButton(
                  onPressed: () => setState(() => qty++),
                  icon: const Icon(Icons.add_circle_outline))
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        widget.cart.add(widget.product, qty);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart')));
                      },
                      child: const Text('Add to Cart'))),
              const SizedBox(width: 10),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        widget.cart.add(widget.product, qty);
                        Navigator.pop(context);
                      },
                      child: const Text('Buy Now')))
            ])
          ]));
}
