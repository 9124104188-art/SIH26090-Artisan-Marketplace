import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override void initState() { super.initState(); Timer(const Duration(seconds: 2), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); }); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Column(children: [const Spacer(), Container(width: 110, height: 110, decoration: const BoxDecoration(color: AppColors.softGreen, shape: BoxShape.circle), child: const Icon(Icons.shopping_cart_rounded, size: 64, color: AppColors.green)), const SizedBox(height: 22), const Text('Artisan Connect', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.darkGreen)), const SizedBox(height: 6), const Text('Handmade. Heartmade.', style: TextStyle(color: AppColors.muted, fontSize: 14)), const Spacer(), Container(width: double.infinity, padding: const EdgeInsets.all(18), color: AppColors.softGreen, child: const Column(children: [Text('Support Artisans', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkGreen)), Text('Build a Better Tomorrow', style: TextStyle(color: AppColors.muted, fontSize: 12))])), ])));
}
