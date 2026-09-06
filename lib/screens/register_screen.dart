import 'package:flutter/material.dart';
import 'main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final p1 = TextEditingController();
  final p2 = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(children: [
            const SizedBox(height: 15),
            const Text('Join our community',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 28),
            TextField(
                controller: name,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Full Name')),
            const SizedBox(height: 14),
            TextField(
                controller: email,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined), hintText: 'Email')),
            const SizedBox(height: 14),
            TextField(
                controller: p1,
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: 'Password')),
            const SizedBox(height: 14),
            TextField(
                controller: p2,
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                    hintText: 'Confirm Password')),
            const SizedBox(height: 22),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainShell()),
                        (r) => false),
                    child: const Text('Register'))),
            const SizedBox(height: 20),
            const Row(children: [
              Expanded(child: Divider()),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR')),
              Expanded(child: Divider())
            ]),
            const SizedBox(height: 12),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata_rounded),
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48))),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Already have an account? Login'))
          ])));
}
