import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final int cartCount;
  const AppBottomNav({super.key, required this.selected, required this.onChanged, this.cartCount = 0});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selected,
      onDestinationSelected: onChanged,
      backgroundColor: Colors.white,
      indicatorColor: AppColors.softGreen,
      destinations: [
        const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
        const NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
        NavigationDestination(icon: Badge(isLabelVisible: cartCount > 0, label: Text('$cartCount'), child: const Icon(Icons.shopping_cart_outlined)), selectedIcon: Badge(isLabelVisible: cartCount > 0, label: Text('$cartCount'), child: const Icon(Icons.shopping_cart_rounded)), label: 'Cart'),
        const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
        const NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }
}
