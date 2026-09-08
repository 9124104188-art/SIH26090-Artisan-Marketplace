import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/step_track.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _nameController = TextEditingController(text: appState.draftName);
    _descController = TextEditingController(text: appState.draftDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _goToAiResults() {
    final appState = context.read<AppState>();
    appState.draftName = _nameController.text;
    appState.draftDescription = _descController.text;

    if (appState.draftName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please tell us what you made first.')),
      );
      return;
    }

    appState.goTo(AppPage.aiResults);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final hasPhoto = appState.draftPhotoPath != null;

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(
        title: appState.t('qa_add_product'),
        onBack: () => appState.goTo(AppPage.home),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(appState.t('add_product_heading'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(appState.t('add_product_subtext'), style: const TextStyle(color: AppColors.muted, fontSize: 13.5)),
          const SizedBox(height: 18),

          Text(appState.t('what_did_you_make'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Example: Handmade Cotton Saree'),
          ),
          const SizedBox(height: 16),

          Text(appState.t('tell_us_about_it'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          const SizedBox(height: 6),
          TextField(
            controller: _descController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'For example: Cotton saree made using traditional handloom techniques...',
            ),
          ),
          const SizedBox(height: 18),

          // AI helper note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appState.t('ai_help_title'), style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(appState.t('ai_help_text'), style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          Text(appState.t('show_or_tell'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(appState.t('choose_easier'), style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _MediaOption(
                  onTap: () => appState.goTo(AppPage.camera),
                  child: hasPhoto
                      ? Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(appState.draftPhotoPath!),
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('✓ Photo added',
                                style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 13)),
                            const Text('Tap to change photo',
                                style: TextStyle(color: AppColors.muted, fontSize: 11.5)),
                          ],
                        )
                      : Column(
                          children: [
                            const Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 26),
                            const SizedBox(height: 8),
                            Text(appState.t('take_photo'), style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(appState.t('show_product'), style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                          ],
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MediaOption(
                  onTap: () => appState.goTo(AppPage.voice),
                  child: Column(
                    children: [
                      const Icon(Icons.mic_none_outlined, color: AppColors.secondary, size: 26),
                      const SizedBox(height: 8),
                      Text(appState.t('speak'), style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(appState.t('tell_naturally'), style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _goToAiResults,
            icon: const Icon(Icons.auto_awesome),
            label: Text(appState.t('continue_listing_btn')),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaOption extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _MediaOption({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: child,
      ),
    );
  }
}
