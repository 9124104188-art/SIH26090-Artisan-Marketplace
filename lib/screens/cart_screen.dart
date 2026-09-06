import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final CartController cart;
  const CartScreen({super.key, required this.cart});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: cart,
    builder: (_, __) => cart.products.isEmpty
      ? const Center(child: Text('Your cart is empty'))
      : ListView(padding: const EdgeInsets.all(14), children: [
          const Text('My Cart', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...cart.products.map((p) => ListTile(
            leading: ProductImage(url: p.imageUrl, width: 64, height: 64),
            title: Text(p.name),
            subtitle: Text('₹${p.price} x ${cart.quantity(p)}'),
            trailing: IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.red), onPressed: () => cart.remove(p)),
          )),
          const Divider(),
          _row('Subtotal', '₹${cart.subtotal}'),
          _row('Shipping', cart.shipping == 0 ? 'Free' : '₹${cart.shipping}'),
          _row('Total', '₹${cart.total}', bold: true),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(cart: cart))), child: const Text('Proceed to Checkout')),
        ],),
  );
  Widget _row(String label, String value, {bool bold = false}) => Row(children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w500)), const Spacer(), Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w800, color: bold ? AppColors.green : null))]);
}
