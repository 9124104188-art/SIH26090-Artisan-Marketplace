import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_nav.dart';
import 'my_products_screen.dart' show statusChipColors, statusLabel;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greetingKey() {
    final hour = DateTime.now().hour;
    if (hour >= 12 && hour < 17) return 'greeting_afternoon';
    if (hour >= 17) return 'greeting_evening';
    return 'greeting_morning';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppBar(
        title: Text(
          'ArtisanAI',
          style: GoogleFonts.fraunces(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            fontSize: 21,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.primary),
            onPressed: () => context.read<AppState>().goTo(AppPage.profile),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // ---------------- Welcome / hero panel ----------------
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, Color(0xFFA9713F), AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appState.t(_greetingKey())}, ${appState.currentUserName} 👋',
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  appState.t('welcome_msg'),
                  style: const TextStyle(color: Color(0xE6FFF9F0), fontSize: 15),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => appState.startNewProduct(),
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryDark),
                  label: Text(
                    appState.t('add_new_product_btn'),
                    style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatPill(number: '${appState.publishedCount}', label: appState.t('stat_products')),
                    const SizedBox(width: 10),
                    _StatPill(number: '2', label: appState.t('stat_orders')),
                    const SizedBox(width: 10),
                    _StatPill(number: '₹${appState.totalEarned.toStringAsFixed(0)}', label: appState.t('stat_earned')),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),
          Text(appState.t('quick_actions'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted)),
          const SizedBox(height: 12),

          // ---------------- Quick actions grid ----------------
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              _QuickAction(
                icon: Icons.add_circle_outline,
                label: appState.t('qa_add_product'),
                bg: AppColors.primaryLight,
                fg: AppColors.primary,
                onTap: () => appState.startNewProduct(),
              ),
              _QuickAction(
                icon: Icons.inventory_2_outlined,
                label: appState.t('qa_my_products'),
                bg: AppColors.successLight,
                fg: AppColors.success,
                onTap: () => appState.goTo(AppPage.myProducts),
              ),
              _QuickAction(
                icon: Icons.shopping_bag_outlined,
                label: appState.t('stat_orders'),
                bg: AppColors.warningLight,
                fg: AppColors.warning,
                onTap: () => appState.goTo(AppPage.orders),
              ),
              _QuickAction(
                icon: Icons.person_outline,
                label: appState.t('qa_profile'),
                bg: AppColors.secondaryLight,
                fg: AppColors.secondary,
                onTap: () => appState.goTo(AppPage.profile),
              ),
            ],
          ),

          const SizedBox(height: 22),
          Text('Recent products', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted)),
          const SizedBox(height: 12),

          // ---------------- Recent products ----------------
          if (appState.products.isEmpty)
            _EmptyProductsCard(onAdd: () => appState.startNewProduct())
          else
            ...appState.products.take(2).map((p) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _Thumb(path: p.photoPath),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('₹${p.price.toStringAsFixed(0)}',
                                      style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                                  const SizedBox(width: 8),
                                  _StatusChip(status: p.status),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String number;
  final String label;
  const _StatPill({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(number,
                style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xE6FFF9F0))),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: fg),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _EmptyProductsCard extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyProductsCard({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.shopping_basket_outlined, size: 32, color: AppColors.secondary),
          const SizedBox(height: 8),
          const Text('No products yet', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text(
            'Your first handmade product is waiting to be added.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String? path;
  const _Thumb({this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: path != null
          ? Image.file(File(path!), fit: BoxFit.cover)
          : const Icon(Icons.image_outlined, color: AppColors.primary),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = statusChipColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: colors.$2, borderRadius: BorderRadius.circular(20)),
      child: Text(statusLabel(status), style: TextStyle(color: colors.$1, fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }
}
