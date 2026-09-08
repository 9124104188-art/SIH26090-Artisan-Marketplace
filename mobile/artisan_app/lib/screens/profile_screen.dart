import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/app_bottom_nav.dart';
import '../l10n/app_translations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _nameController = TextEditingController(text: appState.currentUserName);
    _emailController = TextEditingController(
      text: appState.currentUserEmail.isEmpty ? 'artisan@email.com' : appState.currentUserEmail,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final initial = appState.currentUserName.isNotEmpty
        ? appState.currentUserName[0].toUpperCase()
        : 'A';

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppNavBar(title: appState.t('nav_my_profile')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: GoogleFonts.fraunces(fontSize: 38, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(appState.currentUserName,
                style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined, size: 15, color: AppColors.muted),
                SizedBox(width: 4),
                Text('Chennai, Tamil Nadu', style: TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _StatBox(number: '${appState.publishedCount}', label: appState.t('stat_products'))),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(number: '2', label: appState.t('stat_orders'))),
            ],
          ),
          const SizedBox(height: 18),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 6),
                  TextField(controller: _nameController),
                  const SizedBox(height: 14),
                  const Text('Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 6),
                  TextField(controller: _emailController),
                  const SizedBox(height: 14),
                  Text(appState.t('phone_label'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 6),
                  const TextField(decoration: InputDecoration(hintText: '+91')),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved.')),
                      );
                    },
                    child: Text(appState.t('save_profile_btn')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ---------------- Language selector ----------------
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App Language', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppTranslations.supportedLanguages.map((lang) {
                      final selected = appState.currentLanguage == lang['code'];
                      return ChoiceChip(
                        label: Text(lang['label']!),
                        selected: selected,
                        onSelected: (_) => appState.setLanguage(lang['code']!),
                        selectedColor: AppColors.primaryLight,
                        labelStyle: TextStyle(
                          color: selected ? AppColors.primaryDark : AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: () => appState.logout(),
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: Text(appState.t('logout_btn'), style: const TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.danger),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String number;
  final String label;
  const _StatBox({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(number,
              style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primary)),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
        ],
      ),
    );
  }
}
