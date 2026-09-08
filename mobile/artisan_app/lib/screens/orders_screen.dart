import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';

class _DemoOrder {
  final String id;
  final String product;
  final int quantity;
  final String placedDate;
  final double price;
  final String status;

  const _DemoOrder({
    required this.id,
    required this.product,
    required this.quantity,
    required this.placedDate,
    required this.price,
    required this.status,
  });
}

// Demo order data, matching the two static orders in the original prototype.
// REAL API INTEGRATION POINT: replace this with data from an Orders API.
const List<_DemoOrder> _demoOrders = [
  _DemoOrder(
    id: '#1024',
    product: 'Handmade Cotton Saree',
    quantity: 1,
    placedDate: '3 Sep 2026',
    price: 1499,
    status: 'Pending',
  ),
  _DemoOrder(
    id: '#1023',
    product: 'Handmade Wooden Bowl',
    quantity: 2,
    placedDate: '28 Aug 2026',
    price: 900,
    status: 'Delivered',
  ),
];

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;
      case 'Confirmed':
        return AppColors.secondary;
      case 'Shipped':
        return const Color(0xFF3D5C82);
      case 'Delivered':
      default:
        return AppColors.success;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warningLight;
      case 'Confirmed':
        return AppColors.secondaryLight;
      case 'Shipped':
        return const Color(0xFFDCE7F3);
      case 'Delivered':
      default:
        return AppColors.successLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(title: appState.t('nav_orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: _demoOrders.length,
        itemBuilder: (context, index) {
          final order = _demoOrders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ${order.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusBg(order.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(color: _statusColor(order.status), fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(order.product),
                  const SizedBox(height: 2),
                  Text(
                    'Quantity: ${order.quantity} · Placed ${order.placedDate}',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
                  ),
                  const SizedBox(height: 8),
                  Text('₹${order.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
