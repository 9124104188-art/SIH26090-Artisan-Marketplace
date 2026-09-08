import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/step_track.dart';

class EditPublishScreen extends StatefulWidget {
  const EditPublishScreen({super.key});

  @override
  State<EditPublishScreen> createState() => _EditPublishScreenState();
}

class _EditPublishScreenState extends State<EditPublishScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late String _category;
  bool _isPublishing = false;

  static const List<String> _categories = ['Clothing', 'Home Decor', 'Jewelry', 'Pottery'];

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    final editing = appState.editingProductId != null
        ? appState.findProduct(appState.editingProductId!)
        : null;

    _nameController = TextEditingController(
      text: editing?.name ?? (appState.draftName.isNotEmpty ? appState.draftName : 'Handmade Cotton Saree'),
    );
    _descController = TextEditingController(
      text: editing?.description ??
          (appState.draftDescription.isNotEmpty
              ? appState.draftDescription
              : 'A beautifully handcrafted cotton saree created using traditional artisan techniques.'),
    );
    _priceController = TextEditingController(text: (editing?.price ?? 1499).toStringAsFixed(0));
    _category = editing?.category ?? _categories.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final appState = context.read<AppState>();
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(appState.t('toast_need_name'))));
      return;
    }

    setState(() => _isPublishing = true);

    await appState.publishProduct(
      name: name,
      description: _descController.text.trim(),
      category: _category,
      price: double.tryParse(_priceController.text) ?? 0,
    );

    if (mounted) {
      setState(() => _isPublishing = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(appState.t('toast_product_live'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final photo = appState.draftPhotoPath;

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(
        title: appState.t('edit_publish_btn'),
        onBack: () => appState.goTo(AppPage.pricing),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const StepTrack(
            steps: ['Details', 'Media', 'AI Insights', 'Pricing', 'Publish'],
            activeIndex: 4,
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: photo != null
                        ? Image.file(File(photo), fit: BoxFit.cover)
                        : const Icon(Icons.image_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appState.t('ready_publish_title'),
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(appState.t('ready_publish_text'),
                            style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(appState.t('product_name_field'),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 6),
                  TextField(controller: _nameController),
                  const SizedBox(height: 14),

                  Text(appState.t('description_label'),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 6),
                  TextField(controller: _descController, maxLines: 4),
                  const SizedBox(height: 14),

                  Text(appState.t('category_field'),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _category = value);
                    },
                  ),
                  const SizedBox(height: 14),

                  Text(appState.t('price_label'),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(prefixText: '₹ '),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _isPublishing ? null : _publish,
                    icon: _isPublishing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(appState.t('publish_product_btn')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
