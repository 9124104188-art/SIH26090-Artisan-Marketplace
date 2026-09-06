import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../controllers/artisan_controller.dart';
import 'main_shell.dart';

class RegisterScreen extends StatefulWidget {
  final String initialRole;
  const RegisterScreen({super.key, this.initialRole = 'artisan'});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _craftController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late String _role;
  final bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _role = widget.initialRole;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _craftController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ArtisanController().switchRole(_role);
    if (_role == 'artisan') {
      ArtisanController().updateArtisanProfile(
        name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Artisan',
        category: _craftController.text.trim().isNotEmpty ? _craftController.text.trim() : 'Handicrafts',
        city: _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : 'India',
      );
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join the Artisan Community',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Register to sell handcrafted products or buy directly from local artisans.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Role selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = 'artisan'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _role == 'artisan' ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Register as Artisan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _role == 'artisan' ? Colors.white : AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = 'buyer'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _role == 'buyer' ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Register as Buyer',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _role == 'buyer' ? Colors.white : AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: _nameController,
                  labelText: _role == 'artisan' ? 'Artisan / Studio Name' : 'Full Name',
                  hintText: _role == 'artisan' ? 'e.g. Ramesh Handlooms' : 'Enter your full name',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'name@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter your email';
                    if (!val.contains('@')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                if (_role == 'artisan') ...[
                  CustomTextField(
                    controller: _craftController,
                    labelText: 'Primary Craft Specialization',
                    hintText: 'e.g. Pottery, Terracotta, Terracotta Lamp, Handloom',
                    prefixIcon: Icons.handyman_outlined,
                    validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your craft' : null,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: _cityController,
                    labelText: 'City / Location',
                    hintText: 'e.g. Thanjavur, Tamil Nadu',
                    prefixIcon: Icons.location_on_outlined,
                    validator: (val) => val == null || val.trim().isEmpty ? 'Please enter city' : null,
                  ),
                  const SizedBox(height: 14),
                ],

                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Create a strong password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter password';
                    if (val.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icons.lock_reset_rounded,
                  obscureText: _obscurePassword,
                  validator: (val) {
                    if (val != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                CustomButton(
                  label: _role == 'artisan' ? 'Create Artisan Account' : 'Create Customer Account',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 18),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ', style: TextStyle(color: AppColors.textMuted)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
