import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final CartController cart;
  const OrderSuccessScreen({super.key, required this.cart});
  @override Widget build(BuildContext context) => Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(26), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.check_circle, color: AppColors.green, size: 80), const SizedBox(height: 18), const Text('Order Placed Successfully!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 24),
    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const OrdersScreen()), (route) => false), child: const Text('View My Orders'))),
  ]))));
}
