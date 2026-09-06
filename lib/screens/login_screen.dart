import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;

  void login() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(child: Icon(Icons.shopping_bag_rounded, color: AppColors.green, size: 60)),
                const SizedBox(height: 18),
                const Center(child: Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
                const SizedBox(height: 5),
                const Center(child: Text('Login to continue', style: TextStyle(color: AppColors.muted))),
                const SizedBox(height: 35),
                TextField(controller: email, decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined), hintText: 'Email')),
                const SizedBox(height: 14),
                TextField(
                  controller: password,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Password',
                    suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                  ),
                ),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot Password?'))),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: login, child: const Text('Login'))),
                const SizedBox(height: 16),
                const Center(child: Text('OR')),
                const SizedBox(height: 12),
                OutlinedButton.icon(onPressed: login, icon: const Icon(Icons.g_mobiledata_rounded), label: const Text('Continue with Google'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48))),
                const SizedBox(height: 10),
                OutlinedButton.icon(onPressed: login, icon: const Icon(Icons.phone_android_rounded), label: const Text('Continue with Phone'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48))),
                const SizedBox(height: 18),
                Center(child: Wrap(children: [
                  const Text("Don't have an account? "),
                  TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Register')),
                ])),
              ],
            ),
          ),
        ),
      );
}
