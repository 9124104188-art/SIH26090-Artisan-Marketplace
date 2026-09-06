import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'order_success_screen.dart';

class OrderReviewScreen extends StatelessWidget {
  final CartController cart;
  const OrderReviewScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Review Order')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _header(),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.w900)),
                  SizedBox(height: 7),
                  Text('John Doe\n123, Anna Nagar, Chennai – 600040, Tamil Nadu', style: TextStyle(color: AppColors.muted, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text('Items', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            ...cart.products.map((p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('x${cart.quantity(p)}'),
                  trailing: Text('₹${p.price * cart.quantity(p)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                )),
            const Divider(),
            _row('Subtotal', '₹${cart.subtotal}'),
            _row('Shipping', cart.shipping == 0 ? 'Free' : '₹${cart.shipping}'),
            _row('Total', '₹${cart.total}', bold: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => OrderSuccessScreen(cart: cart)),
                ),
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      );
}

Widget _header() => const Row(
      children: [
        _Circle(1, 'Address', true),
        Expanded(child: Divider()),
        _Circle(2, 'Payment', true),
        Expanded(child: Divider()),
        _Circle(3, 'Review', true),
      ],
    );

Widget _row(String a, String b, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(a, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w500)),
          const Spacer(),
          Text(
            b,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w800,
              color: bold ? AppColors.green : null,
            ),
          ),
        ],
      ),
    );

class _Circle extends StatelessWidget {
  final int n;
  final String l;
  final bool active;

  const _Circle(this.n, this.l, this.active);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: active ? AppColors.green : Colors.grey,
            child: Text('$n', style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          Text(l, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      );
}
