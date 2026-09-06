import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../controllers/artisan_controller.dart';

class AppBottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final int cartCount;

  const AppBottomNav({
    super.key,
    required this.selected,
    required this.onChanged,
    this.cartCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final artisanController = ArtisanController();

    return AnimatedBuilder(
      animation: artisanController,
      builder: (context, _) {
        final isArtisan = artisanController.isArtisan;

        final destinations = isArtisan
            ? [
                const NavigationDestination(
                  icon: Icon(Icons.dashboard_customize_outlined),
                  selectedIcon: Icon(Icons.dashboard_customize_rounded),
                  label: 'Dashboard',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront_rounded),
                  label: 'Marketplace',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.add_circle_outline_rounded),
                  selectedIcon: Icon(Icons.add_circle_rounded),
                  label: 'Add Product',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ]
            : [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Categories',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text('$cartCount'),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text('$cartCount'),
                    child: const Icon(Icons.shopping_cart_rounded),
                  ),
                  label: 'Cart',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ];

        return NavigationBar(
          selectedIndex: selected >= destinations.length ? 0 : selected,
          onDestinationSelected: onChanged,
          backgroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          indicatorColor: AppColors.primarySoft,
          destinations: destinations,
        );
      },
    );
  }
}
