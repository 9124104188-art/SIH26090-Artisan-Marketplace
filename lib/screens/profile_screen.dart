import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'orders_screen.dart';
import 'payment_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'John Doe';
  String _email = 'john@gmail.com';
  String _phone = '+91 98765 43210';

  void _handleAction(BuildContext context, String title) {
    switch (title) {
      case 'Edit Profile':
        _showEditProfileSheet(context);
        break;
      case 'Manage Addresses':
        _showInfoSheet(context, 'Manage Addresses',
            'Saved addresses: Home, Office, and Workshop. You can add or edit them from the next version.');
        break;
      case 'My Orders':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersScreen()),
        );
        break;
      case 'My Wishlist':
        _showInfoSheet(context, 'My Wishlist',
            'Your saved handcrafted favorites will appear here soon.');
        break;
      case 'Payment Methods':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
        );
        break;
      case 'Notifications':
        _showInfoSheet(context, 'Notifications',
            'Order updates and artisan promos are enabled for your account.');
        break;
      case 'Help & Support':
        _showInfoSheet(context, 'Help & Support',
            'Need help? Contact support@artisanconnect.example or call +91 98765 43210.');
        break;
      case 'About Us':
        _showInfoSheet(context, 'About Us',
            'Artisan Connect helps buyers discover, support, and buy authentic handmade products directly from local artisans.');
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
        child: StatefulBuilder(
          builder: (_, setSheetState) => Column(
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final newName = nameController.text.trim();
                    final newEmail = emailController.text.trim();
                    final newPhone = phoneController.text.trim();
                    if (newName.isEmpty || newEmail.isEmpty || newPhone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all profile fields')),
                      );
                      return;
                    }
                    setState(() {
                      _name = newName;
                      _email = newEmail;
                      _phone = newPhone;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.text),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 38)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  Text(_email, style: const TextStyle(color: AppColors.muted)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _item(Icons.edit_outlined, 'Edit Profile', onTap: () => _handleAction(context, 'Edit Profile')),
        _item(Icons.location_on_outlined, 'Manage Addresses', onTap: () => _handleAction(context, 'Manage Addresses')),
        _item(Icons.receipt_long_outlined, 'My Orders', onTap: () => _handleAction(context, 'My Orders')),
        _item(Icons.favorite_border, 'My Wishlist', onTap: () => _handleAction(context, 'My Wishlist')),
        _item(Icons.credit_card_outlined, 'Payment Methods', onTap: () => _handleAction(context, 'Payment Methods')),
        _item(Icons.notifications_none, 'Notifications', onTap: () => _handleAction(context, 'Notifications')),
        _item(Icons.help_outline, 'Help & Support', onTap: () => _handleAction(context, 'Help & Support')),
        _item(Icons.info_outline, 'About Us', onTap: () => _handleAction(context, 'About Us')),
        const SizedBox(height: 10),
        _item(
          Icons.logout,
          'Logout',
          red: true,
          onTap: () => _handleAction(context, 'Logout'),
        ),
      ],
    );
  }

  Widget _item(IconData icon, String title,
          {bool red = false, VoidCallback? onTap}) =>
      ListTile(
        onTap: onTap,
        leading: Icon(icon, color: red ? AppColors.red : AppColors.text),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: red ? AppColors.red : AppColors.text,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      );
}

