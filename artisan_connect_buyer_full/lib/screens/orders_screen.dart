import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../services/api_client.dart';
import 'tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  final VoidCallback? onOpenTracking;
  final VoidCallback? onBack;
  final VoidCallback? onGoHome;

  const OrdersScreen({
    super.key,
    this.onOpenTracking,
    this.onBack,
    this.onGoHome,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _orderService = OrderService();
  late Future<List<Map<String, dynamic>>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = _orderService.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        actions: [
          TextButton(
            onPressed: widget.onGoHome ??
                () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Go'),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final message = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : 'Unable to load orders.';
            return Center(child: Text(message));
          }
          final orders = snapshot.data ?? [];
          return ListView(
            padding: const EdgeInsets.all(14),
            children: [
              const Text('My Orders',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              if (orders.isEmpty) const Text('No orders yet.'),
              ...orders.map((order) {
                final id = order['_id']?.toString() ?? 'Order';
                final items = order['items'] as List<dynamic>? ?? [];
                final first =
                    items.isNotEmpty && items.first is Map<String, dynamic>
                        ? items.first as Map<String, dynamic>
                        : <String, dynamic>{};
                final product = first['productId'];
                final title = product is Map<String, dynamic>
                    ? product['title']?.toString() ?? 'Order items'
                    : 'Order items';
                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TrackingScreen(orderId: id))),
                  title: Text('#$id'),
                  subtitle: Text('$title • ${order['status'] ?? 'pending'}'),
                  trailing: Text('₹${order['totalAmount'] ?? 0}'),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
