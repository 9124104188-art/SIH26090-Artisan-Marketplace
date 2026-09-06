import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'order_review_screen.dart';

class PaymentScreen extends StatefulWidget {
  final CartController cart;
  const PaymentScreen({super.key, required this.cart});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String method = 'Google Pay / UPI';
  final _upiController = TextEditingController(text: 'john.doe@oksbi');
  final _cardController = TextEditingController(text: '**** **** **** 4832');

  @override
  void dispose() {
    _upiController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  bool _isUpiMethod(String value) =>
      value == 'Google Pay / UPI' || value == 'PhonePe / UPI' || value == 'Paytm / UPI';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Choose a payment method',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 12),
        Column(
          children: [
            ...[
              'Google Pay / UPI',
              'PhonePe / UPI',
              'Paytm / UPI',
              'Credit / Debit Card',
              'Net Banking',
              'Cash on Delivery'
            ].map((value) => ListTile(
                  onTap: () => setState(() => method = value),
                  leading: Icon(
                    value == method
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: value == method ? AppColors.green : AppColors.muted,
                  ),
                  title: Text(value),
                )),
          ],
        ),
        const SizedBox(height: 18),
        if (_isUpiMethod(method))
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('UPI ID / Mobile Number',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _upiController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'name@upi',
                  ),
                ),
              ],
            ),
          )
        else if (method == 'Credit / Debit Card')
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Card Number',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _cardController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'XXXX XXXX XXXX XXXX',
                  ),
                ),
              ],
            ),
          )
        else if (method == 'Net Banking')
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('You will be redirected to your bank for secure authentication.',
                style: TextStyle(fontSize: 14, height: 1.5)),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('Cash will be collected at the time of delivery.',
                style: TextStyle(fontSize: 14, height: 1.5)),
          ),
        const SizedBox(height: 24),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OrderReviewScreen(cart: widget.cart))),
                child: const Text('Continue to Review'))),
      ]));
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final methods = [
    'Google Pay / UPI',
    'PhonePe / UPI',
    'Paytm / UPI',
    'Credit / Debit Card',
    'Net Banking',
    'Cash on Delivery'
  ];
  String selected = 'Google Pay / UPI';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Payment Methods')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Saved methods',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...methods.map((method) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: selected == method ? AppColors.softGreen : Colors.white,
                    border: Border.all(
                      color: selected == method ? AppColors.green : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    onTap: () => setState(() => selected = method),
                    leading: Icon(
                      selected == method
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected == method ? AppColors.green : AppColors.muted,
                    ),
                    title: Text(method),
                  ),
                )),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: $selected')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Payment Method'),
              ),
            ),
          ],
        ),
      );
}
