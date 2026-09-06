import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ArtisanDetailsScreen extends StatelessWidget {
  final String artisan;
  final List<Product> products;
  const ArtisanDetailsScreen(
      {super.key, required this.artisan, required this.products});
  @override
  Widget build(BuildContext context) {
    final p = products.isEmpty ? [] : products;
    return Scaffold(
        appBar: AppBar(title: const Text('Artisan Details')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 52)),
          const SizedBox(height: 10),
          Center(
              child: Text(artisan,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900))),
          const Center(
              child: Text('Traditional handmade artisan',
                  style: TextStyle(color: AppColors.muted))),
          const SizedBox(height: 10),
          const Center(
              child: Text('⭐ 4.8 (120 reviews) · Tamil Nadu',
                  style: TextStyle(
                      color: AppColors.gold, fontWeight: FontWeight.w700))),
          const SizedBox(height: 18),
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(16)),
              child: const Text(
                  'We are a family of artisans creating traditional handmade goods. Our products are made with care and reflect our culture and heritage.',
                  style: TextStyle(height: 1.5))),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(
                child: Text('Our Products',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
            TextButton(onPressed: () {}, child: const Text('View All'))
          ]),
          if (p.isEmpty)
            const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: Text('Artisan product collection'))),
          if (p.isNotEmpty)
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: p.take(6).length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .65),
                itemBuilder: (c, i) =>
                    ProductCard(product: p[i], onTap: () {}, onAdd: () {}))
        ]));
  }
}
