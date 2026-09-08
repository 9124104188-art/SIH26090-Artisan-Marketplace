import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

/// Converts:
/// <div id="bottomNav" class="bottom-nav">
///   <button onclick="showPage('homePage', this)">Home</button>
///   ...
/// </div>
/// Hidden on the login/register pages, exactly like the original
/// `bottomNav.style.display = 'none'` logic.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final current = appState.currentPage;

    final items = <_NavItem>[
      _NavItem(AppPage.home, Icons.home_outlined, appState.t('nav_home')),
      _NavItem(AppPage.addProduct, Icons.add_circle_outline, appState.t('nav_add')),
      _NavItem(AppPage.myProducts, Icons.inventory_2_outlined, appState.t('nav_products')),
      _NavItem(AppPage.orders, Icons.shopping_bag_outlined, appState.t('nav_orders')),
      _NavItem(AppPage.profile, Icons.person_outline, appState.t('qa_profile')),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            final active = item.page == current;
            return _NavButton(
              item: item,
              active: active,
              onTap: () {
                if (item.page == AppPage.addProduct) {
                  context.read<AppState>().startNewProduct();
                } else {
                  context.read<AppState>().goTo(item.page);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final AppPage page;
  final IconData icon;
  final String label;
  _NavItem(this.page, this.icon, this.label);
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : const Color(0xFF9C8E80);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                color: color,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
