import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/step_track.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(
        title: appState.t('nav_smart_pricing'),
        onBack: () => appState.goTo(AppPage.aiResults),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const StepTrack(
            steps: ['Details', 'Media', 'AI Insights', 'Pricing', 'Publish'],
            activeIndex: 3,
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text(appState.t('ai_recommended_price'),
                    style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600, fontSize: 12.5)),
                const SizedBox(height: 6),
                Text('₹1,499',
                    style: GoogleFonts.fraunces(
                        fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                const SizedBox(height: 6),
                Text(appState.t('price_basis_text'),
                    textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appState.t('estimated_range_label')),
                      const Text('₹1,200 – ₹1,700', style: TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(appState.t('market_demand_label')),
                      Text(appState.t('demand_high'),
                          style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(appState.t('why_price_summary'),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _FactorRow(
                          icon: Icons.water_drop_outlined,
                          title: appState.t('factor_material_title'),
                          text: appState.t('factor_material_text'),
                        ),
                        _FactorRow(
                          icon: Icons.auto_awesome,
                          title: appState.t('factor_craft_title'),
                          text: appState.t('factor_craft_text'),
                        ),
                        _FactorRow(
                          icon: Icons.grid_view_outlined,
                          title: appState.t('category_field'),
                          text: appState.t('factor_category_text'),
                        ),
                        _FactorRow(
                          icon: Icons.trending_up,
                          title: appState.t('market_demand_label'),
                          text: appState.t('factor_demand_text'),
                        ),
                        _FactorRow(
                          icon: Icons.storefront_outlined,
                          title: appState.t('factor_similar_title'),
                          text: appState.t('factor_similar_text'),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          ElevatedButton(
            onPressed: () => appState.goTo(AppPage.editPublish),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(appState.t('edit_publish_btn')),
          ),
        ],
      ),
    );
  }
}

class _FactorRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final bool isLast;

  const _FactorRow({
    required this.icon,
    required this.title,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
