import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CartController cart;
  const CheckoutScreen({super.key, required this.cart});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String delivery = 'Standard Delivery (3-5 days)';
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Shipping Address',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
        const SizedBox(height: 8),
        const Text('John Doe\n123, Anna Nagar\nChennai - 600040, Tamil Nadu'),
        const SizedBox(height: 20),
        const Text('Delivery Method',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
        RadioGroup<String>(
          groupValue: delivery,
          onChanged: (next) => setState(() => delivery = next!),
          child: Column(children: [
            ...[
              'Standard Delivery (3-5 days)',
              'Express Delivery (1-2 days)',
              'Same Day Delivery'
            ].map((value) => RadioListTile<String>(
                value: value,
                title: Text(value),
                activeColor: AppColors.green)),
          ]),
        ),
        const SizedBox(height: 18),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentScreen(cart: widget.cart))),
                child: const Text('Continue to Payment'))),
      ]));
}
