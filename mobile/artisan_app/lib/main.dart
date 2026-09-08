import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'theme/app_theme.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/voice_screen.dart';
import 'screens/ai_results_screen.dart';
import 'screens/pricing_screen.dart';
import 'screens/edit_publish_screen.dart';
import 'screens/my_products_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const ArtisanAiApp());
}

class ArtisanAiApp extends StatelessWidget {
  const ArtisanAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'ArtisanAI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const RootShell(),
      ),
    );
  }
}

/// Root widget that swaps between screens based on [AppState.currentPage],
/// mirroring the original prototype's showPage()/`.page.active` pattern
/// rather than a push/pop Navigator stack.
class RootShell extends StatelessWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return _buildPage(appState.currentPage);
  }

  Widget _buildPage(AppPage page) {
    switch (page) {
      case AppPage.login:
        return const LoginScreen();
      case AppPage.register:
        return const RegisterScreen();
      case AppPage.home:
        return const HomeScreen();
      case AppPage.addProduct:
        return const AddProductScreen();
      case AppPage.camera:
        return const CameraScreen();
      case AppPage.voice:
        return const VoiceScreen();
      case AppPage.aiResults:
        return const AiResultsScreen();
      case AppPage.pricing:
        return const PricingScreen();
      case AppPage.editPublish:
        return const EditPublishScreen();
      case AppPage.myProducts:
        return const MyProductsScreen();
      case AppPage.orders:
        return const OrdersScreen();
      case AppPage.profile:
        return const ProfileScreen();
    }
  }
}
