import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';

/// Returns (foreground, background) colors for a status chip, converting
/// .status-published / .status-draft / .status-outofstock.
(Color, Color) statusChipColors(String status) {
  switch (status) {
    case 'published':
      return (AppColors.success, AppColors.successLight);
    case 'outofstock':
      return (AppColors.danger, AppColors.dangerLight);
    default:
      return (AppColors.warning, AppColors.warningLight);
  }
}

String statusLabel(String status) {
  switch (status) {
    case 'published':
      return 'Published';
    case 'outofstock':
      return 'Out of Stock';
    default:
      return 'Draft';
  }
}

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(
        title: appState.t('nav_my_products'),
        trailing: IconButton(
          icon: const Icon(Icons.add, color: AppColors.primary),
          onPressed: () => appState.startNewProduct(),
        ),
      ),
      body: appState.products.isEmpty
          ? _EmptyState(onAdd: () => appState.startNewProduct())
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: appState.products.length,
              itemBuilder: (context, index) {
                final p = appState.products[index];
                return _ProductCard(product: p);
              },
            ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final colors = statusChipColors(product.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: product.photoPath != null
                  ? Image.file(File(product.photoPath!), fit: BoxFit.cover)
                  : const Icon(Icons.image_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(product.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18),
                        onSelected: (value) {
                          if (value == 'edit') {
                            appState.openEditProduct(product.id);
                          } else if (value == 'remove') {
                            appState.removeProduct(product.id);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'remove', child: Text('Remove')),
                        ],
                      ),
                    ],
                  ),
                  Text(product.category, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: colors.$2, borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          statusLabel(product.status),
                          style: TextStyle(color: colors.$1, fontSize: 11.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_basket_outlined, size: 36, color: AppColors.secondary),
            const SizedBox(height: 10),
            const Text('No products yet', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 4),
            const Text(
              'Your first handmade product is waiting to be added.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
