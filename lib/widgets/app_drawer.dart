import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BuyerDrawer extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const BuyerDrawer({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          Container(color: AppColors.green, width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 18, 20, 22), child: const Row(children: [CircleAvatar(radius: 27, child: Icon(Icons.person)), SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('John Doe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)), SizedBox(height: 2), Text('john@gmail.com', style: TextStyle(color: Colors.white70, fontSize: 12))])])),
          _item(Icons.home_outlined, 'Home'),
          _item(Icons.grid_view_rounded, 'Categories'),
          _item(Icons.shopping_cart_outlined, 'My Cart'),
          _item(Icons.receipt_long_outlined, 'My Orders'),
          _item(Icons.favorite_border_rounded, 'My Wishlist'),
          _item(Icons.person_outline_rounded, 'My Profile'),
          _item(Icons.settings_outlined, 'Settings'),
          _item(Icons.help_outline_rounded, 'Help & Support'),
          _item(Icons.info_outline_rounded, 'About Us'),
          const Spacer(),
          _item(Icons.logout_rounded, 'Logout', red: true),
          const SizedBox(height: 10),
          const Text('Artisan Connect v1.0.0', style: TextStyle(fontSize: 11, color: AppColors.muted)),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _item(IconData icon, String text, {bool red = false}) => ListTile(leading: Icon(icon, color: red ? AppColors.red : AppColors.text), title: Text(text, style: TextStyle(color: red ? AppColors.red : AppColors.text, fontWeight: FontWeight.w600)), onTap: () => onSelect(text));
}
