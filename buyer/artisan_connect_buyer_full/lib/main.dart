import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArtisanConnectApp());
}

class ArtisanConnectApp extends StatelessWidget {
  const ArtisanConnectApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Artisan Connect',
    theme: buildAppTheme(),
    home: const SplashScreen(),
  );
}
