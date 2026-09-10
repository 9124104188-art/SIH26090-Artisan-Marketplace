import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../controllers/artisan_controller.dart';

class BuyerDrawer extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const BuyerDrawer({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final artisanController = ArtisanController();

    return Drawer(
      backgroundColor: AppColors.bg,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: artisanController,
          builder: (context, _) {
            final isArtisan = artisanController.isArtisan;

            return Column(
              children: [
                Container(
                  color: AppColors.primary,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  artisanController.artisanName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded,
                                    color: AppColors.accent, size: 16),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isArtisan
                                  ? 'Artisan Seller Account'
                                  : 'Marketplace Buyer Account',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      if (isArtisan) ...[
                        _item(Icons.dashboard_customize_rounded,
                            'Artisan Dashboard'),
                        _item(Icons.add_circle_outline_rounded,
                            'Add Product Catalog'),
                        _item(
                            Icons.auto_awesome_rounded, 'AI Smart Cataloging'),
                      ],
                      _item(Icons.home_outlined, 'Home Marketplace'),
                      _item(Icons.grid_view_rounded, 'Categories'),
                      _item(Icons.shopping_cart_outlined, 'My Cart'),
                      _item(Icons.receipt_long_outlined, 'My Orders'),
                      _item(Icons.auto_awesome_outlined, 'AI Recommendations'),
                      _item(Icons.favorite_border_rounded, 'My Wishlist'),
                      _item(Icons.person_outline_rounded, 'My Profile'),
                      const Divider(color: AppColors.border),
                      _item(
                        isArtisan
                            ? Icons.swap_horiz_rounded
                            : Icons.handyman_rounded,
                        isArtisan
                            ? 'Switch to Buyer Marketplace'
                            : 'Switch to Artisan Mode',
                      ),
                      _item(Icons.help_outline_rounded, 'Help & Support'),
                      _item(Icons.info_outline_rounded, 'About SIH26090'),
                    ],
                  ),
                ),
                _item(Icons.logout_rounded, 'Logout', red: true),
                const SizedBox(height: 8),
                const Text(
                  'Artisan Connect v1.0.0 • SIH26090',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                const SizedBox(height: 14),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _item(IconData icon, String text, {bool red = false}) => ListTile(
        leading: Icon(icon,
            color: red ? AppColors.error : AppColors.textPrimary, size: 22),
        title: Text(
          text,
          style: TextStyle(
            color: red ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        onTap: () => onSelect(text),
      );
}
