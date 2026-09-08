import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';

/// Converts #cameraPage. The HTML used a single
/// <input type="file" accept="image/*" capture="environment"> which lets the
/// browser offer either the camera or the gallery — image_picker's
/// showModalBottomSheet choice below is the native equivalent of that same
/// choice, without adding any new functionality beyond what the file input
/// already offered.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Capture photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null && mounted) {
        context.read<AppState>().setDraftPhoto(picked.path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't open the camera/gallery on this device.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final hasPhoto = appState.draftPhotoPath != null;

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(
        title: appState.t('nav_add_photo'),
        onBack: () => appState.goTo(AppPage.addProduct),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 230),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDFA),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFC7A87E), width: 2, style: BorderStyle.solid),
                ),
                child: hasPhoto
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(appState.draftPhotoPath!),
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined, size: 40, color: AppColors.primary),
                          const SizedBox(height: 10),
                          Text(appState.t('camera_tap_title'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(
                            appState.t('camera_tap_subtext'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted, fontSize: 13),
                          ),
                        ],
                      ),
              ),
            ),
            if (hasPhoto) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(appState.t('retake_btn')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => appState.setDraftPhoto(null),
                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                      label: Text(appState.t('remove_btn'), style: const TextStyle(color: AppColors.danger)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => appState.goTo(AppPage.addProduct),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(appState.t('continue_btn')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
