import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/step_track.dart';
import '../widgets/info_card.dart';

class AiResultsScreen extends StatelessWidget {
  const AiResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final photo = appState.draftPhotoPath;
    final name = appState.draftName.trim().isEmpty ? 'Handmade Cotton Saree' : appState.draftName;
    final description = appState.draftDescription.trim().isEmpty
        ? 'A beautifully handcrafted cotton saree created using traditional artisan techniques.'
        : appState.draftDescription;

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(
        title: appState.t('nav_ai_results'),
        onBack: () => appState.goTo(AppPage.addProduct),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const StepTrack(
            steps: ['Details', 'Media', 'AI Insights', 'Pricing', 'Publish'],
            activeIndex: 2,
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                if (photo != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(photo), width: 44, height: 44, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),
                ] else ...[
                  const Icon(Icons.auto_awesome, color: AppColors.success),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    appState.t('ai_found'),
                    style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          InfoCard(
            icon: Icons.sell_outlined,
            label: appState.t('product_name_field'),
            child: Text(name),
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.description_outlined,
            label: appState.t('ai_description_field'),
            child: Text(description),
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.grid_view_outlined,
            label: appState.t('category_field'),
            child: Chip(
              label: const Text('Clothing'),
              backgroundColor: AppColors.primaryLight,
              labelStyle: const TextStyle(color: AppColors.primaryDark),
              side: BorderSide.none,
            ),
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.label_outline,
            label: appState.t('suggested_tags_field'),
            child: Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Handmade'), side: BorderSide.none),
                Chip(label: Text('Cotton'), side: BorderSide.none),
                Chip(label: Text('Traditional'), side: BorderSide.none),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.water_drop_outlined,
            label: appState.t('detected_materials_field'),
            child: const Text('Cotton, natural dyes'),
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.trending_up,
            label: appState.t('ai_confidence_field'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.88,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.success),
                  ),
                ),
                const SizedBox(height: 6),
                Text(appState.t('ai_confidence_text'),
                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(height: 22),

          ElevatedButton.icon(
            onPressed: () => appState.goTo(AppPage.pricing),
            icon: const Icon(Icons.currency_rupee),
            label: Text(appState.t('view_smart_price_btn')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
