import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../widgets/product_image.dart';
import 'tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  final VoidCallback? onOpenTracking;
  const OrdersScreen({super.key, this.onOpenTracking});
  @override
  Widget build(BuildContext context) {
    final products = buildProducts();
    return ListView(padding: const EdgeInsets.all(14), children: [
      const Text('My Orders',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      ...[0, 7, 25, 50].map((index) => ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      const TrackingScreen(orderId: 'AC20260905001'))),
          leading: ProductImage(
              url: products[index].imageUrl, width: 60, height: 60),
          title: const Text('#AC20260905001'),
          subtitle: Text(products[index].name),
          trailing: const Icon(Icons.chevron_right)))
    ]);
  }
}
