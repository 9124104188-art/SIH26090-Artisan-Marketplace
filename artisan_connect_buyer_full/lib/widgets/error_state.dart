import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_button.dart';

class ErrorState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.description = 'Please check your connection and try again.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, size: 38, color: AppColors.error),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textMuted,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 22),
              CustomButton(
                label: 'Retry',
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                width: 140,
                height: 42,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
