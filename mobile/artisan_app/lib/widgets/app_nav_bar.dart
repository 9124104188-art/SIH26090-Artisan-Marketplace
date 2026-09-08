import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Converts the repeated HTML pattern:
/// <nav class="app-navbar">
///   <button class="icon-btn" onclick="showPage(...)"><svg .../></button>
///   <span class="nav-title">Page Title</span>
///   <span style="width:42px"></span>
/// </nav>
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  const AppNavBar({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: onBack,
              tooltip: 'Back',
            )
          : null,
      title: Text(title),
      actions: trailing != null ? [trailing!] : null,
    );
  }
}
