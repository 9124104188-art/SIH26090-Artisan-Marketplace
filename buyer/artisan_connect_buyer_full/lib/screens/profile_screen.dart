import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../controllers/artisan_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';
import 'orders_screen.dart';
import 'payment_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _artisanController = ArtisanController();
  
  late String _name;
  late String _email;
  late String _phone;
  late String _craft;
  late String _city;

  @override
  void initState() {
    super.initState();
    _name = _artisanController.artisanName;
    _email = 'artisan@artisanconnect.org';
    _phone = '+91 98765 43210';
    _craft = _artisanController.artisanCategory;
    _city = _artisanController.artisanCity;
  }

  void _handleAction(BuildContext context, String title) {
    switch (title) {
      case 'Edit Profile':
        _showEditProfileSheet(context);
        break;
      case 'Switch to Artisan Mode':
        _artisanController.switchRole('artisan');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Switched to Artisan Mode'),
            backgroundColor: AppColors.primary,
          ),
        );
        break;
      case 'Switch to Buyer Mode':
        _artisanController.switchRole('buyer');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Switched to Buyer Marketplace'),
            backgroundColor: AppColors.primary,
          ),
        );
        break;
      case 'Manage Addresses':
        _showInfoSheet(
          context,
          'Manage Addresses',
          'Primary Workshop Address: Craft Nagar, Thanjavur, Tamil Nadu - 613001.\nRegistered Delivery Hub: South Zonal Artisan Linkage Center.',
        );
        break;
      case 'My Orders':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersScreen()),
        );
        break;
      case 'My Wishlist':
        _showInfoSheet(
          context,
          'My Wishlist',
          'Your saved handcrafted favorites will appear here.',
        );
        break;
      case 'Payment Methods':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
        );
        break;
      case 'Notifications':
        _showInfoSheet(
          context,
          'Notifications',
          'AI cataloging insights, order status updates, and buyer inquiries are enabled.',
        );
        break;
      case 'Help & Support':
        _showInfoSheet(
          context,
          'Help & Support',
          'SIH26090 Artisan Helpline:\nEmail: support@artisanconnect.gov.in\nPhone: +91 1800 123 4567 (Toll Free)',
        );
        break;
      case 'About SIH26090':
        _showInfoSheet(
          context,
          'About Artisan Connect (SIH26090)',
          'AI-Driven Market Linkage & Smart Cataloging Mobile Application for Marginalized Artisans.\nDesigned for Smart India Hackathon.',
        );
        break;
      case 'Logout':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title is coming soon')),
        );
    }
  }

  void _showEditProfileSheet(BuildContext context) {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);
    final craftController = TextEditingController(text: _craft);
    final cityController = TextEditingController(text: _city);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: nameController,
              labelText: 'Name',
              hintText: 'Enter name',
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: phoneController,
              labelText: 'Phone',
              hintText: 'Enter phone',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: craftController,
              labelText: 'Craft Specialization',
              hintText: 'e.g. Pottery, Handicrafts',
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: cityController,
              labelText: 'City / Region',
              hintText: 'e.g. Thanjavur, Tamil Nadu',
            ),
            const SizedBox(height: 20),

            CustomButton(
              label: 'Save Changes',
              onPressed: () {
                final newName = nameController.text.trim();
                final newEmail = emailController.text.trim();
                final newPhone = phoneController.text.trim();
                final newCraft = craftController.text.trim();
                final newCity = cityController.text.trim();

                if (newName.isEmpty || newEmail.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all profile fields')),
                  );
                  return;
                }

                setState(() {
                  _name = newName;
                  _email = newEmail;
                  _phone = newPhone;
                  _craft = newCraft;
                  _city = newCity;
                });

                _artisanController.updateArtisanProfile(
                  name: newName,
                  category: newCraft,
                  city: newCity,
                );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14.5, height: 1.5, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 22),
            CustomButton(
              label: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _artisanController,
      builder: (context, _) {
        final isArtisan = _artisanController.isArtisan;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User Header Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AppColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, color: AppColors.accent, size: 16),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(_email, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isArtisan ? AppColors.secondarySoft : AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isArtisan ? 'Verified Artisan Seller' : 'Marketplace Customer',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isArtisan ? AppColors.secondary : AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Mode Toggle Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isArtisan ? Icons.handyman_rounded : Icons.shopping_bag_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArtisan ? 'Current: Artisan Dashboard' : 'Current: Buyer Marketplace',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text(
                              isArtisan ? 'Tap to view Marketplace' : 'Tap to access Artisan Cataloging',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _handleAction(
                            context,
                            isArtisan ? 'Switch to Buyer Mode' : 'Switch to Artisan Mode',
                          );
                        },
                        child: Text(isArtisan ? 'Switch Buyer' : 'Switch Artisan'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _item(
                  Icons.edit_outlined,
                  'Edit Profile',
                  onTap: () => _handleAction(context, 'Edit Profile'),
                ),
                _item(
                  Icons.location_on_outlined,
                  'Manage Addresses & Workshop',
                  onTap: () => _handleAction(context, 'Manage Addresses'),
                ),
                _item(
                  Icons.receipt_long_outlined,
                  'My Orders & Fulfillment',
                  onTap: () => _handleAction(context, 'My Orders'),
                ),
                _item(
                  Icons.favorite_border,
                  'Saved Catalog Wishlist',
                  onTap: () => _handleAction(context, 'My Wishlist'),
                ),
                _item(
                  Icons.credit_card_outlined,
                  'Bank & Payment Methods',
                  onTap: () => _handleAction(context, 'Payment Methods'),
                ),
                _item(
                  Icons.notifications_none_rounded,
                  'Notifications & Alerts',
                  onTap: () => _handleAction(context, 'Notifications'),
                ),
                _item(
                  Icons.help_outline_rounded,
                  'Artisan Help & Support',
                  onTap: () => _handleAction(context, 'Help & Support'),
                ),
                _item(
                  Icons.info_outline_rounded,
                  'About SIH26090 Project',
                  onTap: () => _handleAction(context, 'About SIH26090'),
                ),
                const SizedBox(height: 10),
                _item(
                  Icons.logout_rounded,
                  'Logout',
                  red: true,
                  onTap: () => _handleAction(context, 'Logout'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _item(
    IconData icon,
    String title, {
    bool red = false,
    VoidCallback? onTap,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: red ? AppColors.error : AppColors.textPrimary, size: 20),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: red ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
        ),
      );
}
