import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Converts the .step-track / .step / .step.done / .step.active markup used
/// on the Add Product → AI Results → Pricing → Publish flow.
class StepTrack extends StatelessWidget {
  final List<String> steps;
  final int activeIndex; // 0-based index of the current step

  const StepTrack({
    super.key,
    required this.steps,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isDone = i < activeIndex;
          final isActive = i == activeIndex;
          final color = isActive
              ? AppColors.primary
              : (isDone ? AppColors.success : AppColors.muted);
          final barColor = isActive
              ? AppColors.primary
              : (isDone ? AppColors.success : AppColors.border);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  Container(height: 4, color: barColor),
                  const SizedBox(height: 6),
                  Text(
                    steps[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
