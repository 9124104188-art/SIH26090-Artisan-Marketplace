import 'package:flutter/material.dart';

/// Colors ported 1:1 from the original prototype's CSS custom properties
/// (:root { --primary: #8B5A2B; ... }) so the Flutter app keeps the same
/// warm, artisan visual identity.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF8B5A2B);
  static const Color primaryDark = Color(0xFF5C3A1B);
  static const Color primaryLight = Color(0xFFF3E4D2);

  static const Color secondary = Color(0xFFC1694A);
  static const Color secondaryLight = Color(0xFFF1DACB);

  static const Color cream = Color(0xFFFBF4E9);
  static const Color card = Color(0xFFFFFFFF);

  static const Color text = Color(0xFF2E2117);
  static const Color muted = Color(0xFF8A7A6C);
  static const Color border = Color(0xFFEAD9C4);

  static const Color success = Color(0xFF5B7B4F);
  static const Color successLight = Color(0xFFE4EDDD);

  static const Color warning = Color(0xFFB7862E);
  static const Color warningLight = Color(0xFFF6E9CE);

  static const Color danger = Color(0xFFB5473A);
  static const Color dangerLight = Color(0xFFF5DEDA);
}
