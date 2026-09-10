import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../controllers/artisan_controller.dart';
import '../services/auth_service.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_theme.dart';
import 'artisan_dashboard_screen.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'product_details_screen.dart';
import 'add_product_screen.dart';
import 'ai_cataloging_screen.dart';
import 'recommendations_screen.dart';
import 'login_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  final cart = CartController();
  final artisanController = ArtisanController();
  int index = 0;

  @override
  void initState() {
    super.initState();
    artisanController.loadProducts();
  }

  void go(int i) => setState(() => index = i);

  void openProduct(product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: product, cart: cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([cart, artisanController]),
      builder: (context, _) {
        final isArtisan = artisanController.isArtisan;

        final pages = isArtisan
            ? [
                ArtisanDashboardScreen(
                  cart: cart,
                  onProductTap: (p) => openProduct(p),
                ),
                HomeScreen(onProduct: (p) => openProduct(p), cart: cart),
                const AddProductScreen(),
                OrdersScreen(
                  onOpenTracking: () => go(3),
                  onBack: () => go(1),
                  onGoHome: () => go(1),
                ),
                const ProfileScreen(),
              ]
            : [
                HomeScreen(onProduct: (p) => openProduct(p), cart: cart),
                CategoryScreen(onProduct: (p) => openProduct(p), cart: cart),
                CartScreen(cart: cart),
                OrdersScreen(
                  onOpenTracking: () => go(3),
                  onBack: () => go(0),
                  onGoHome: () => go(0),
                ),
                const ProfileScreen(),
              ];

        return PopScope<void>(
          canPop: index == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && index != 0) go(0);
          },
          child: Scaffold(
            drawer: BuyerDrawer(
              onSelect: (s) {
                Navigator.pop(context);
                if (s == 'Artisan Dashboard') {
                  artisanController.switchRole('artisan');
                  go(0);
                } else if (s == 'Add Product Catalog') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProductScreen()),
                  );
                } else if (s == 'AI Smart Cataloging') {
                  Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AICatalogingScreen()),
                  ).then((result) {
                    if (!context.mounted || result == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddProductScreen(aiCatalogData: result),
                      ),
                    );
                  });
                } else if (s == 'Home Marketplace' || s == 'Home') {
                  go(isArtisan ? 1 : 0);
                } else if (s == 'Categories') {
                  go(isArtisan ? 1 : 1);
                } else if (s == 'My Cart') {
                  go(isArtisan ? 1 : 2);
                } else if (s == 'My Orders') {
                  go(3);
                } else if (s == 'AI Recommendations') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecommendationsScreen(
                        products: artisanController.allProducts,
                        preferenceProducts: cart.products,
                        onProduct: openProduct,
                      ),
                    ),
                  );
                } else if (s == 'My Profile') {
                  go(4);
                } else if (s == 'Logout') {
                  AuthService().logout().then((_) {
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  });
                } else if (s.contains('Switch to Buyer')) {
                  artisanController.switchRole('buyer');
                  go(0);
                } else if (s.contains('Switch to Artisan')) {
                  artisanController.switchRole('artisan');
                  go(0);
                }
              },
            ),
            appBar: AppBar(
              leading: Builder(
                builder: (c) => IconButton(
                  onPressed: () => Scaffold.of(c).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.palette_rounded,
                      color: AppColors.primary, size: 22),
                  const SizedBox(width: 6),
                  const Text(
                    'Artisan Connect',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isArtisan
                          ? AppColors.secondarySoft
                          : AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isArtisan ? 'ARTISAN' : 'BUYER',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: isArtisan
                            ? AppColors.secondary
                            : AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                if (isArtisan)
                  IconButton(
                    tooltip: 'AI Smart Cataloging',
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AICatalogingScreen()),
                      );
                      if (!context.mounted || result == null) return;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddProductScreen(aiCatalogData: result),
                        ),
                      );
                    },
                    icon: const Icon(Icons.auto_awesome_rounded,
                        color: AppColors.secondary),
                  ),
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(
                        products: artisanController.allProducts,
                        cart: cart,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
                if (!isArtisan)
                  IconButton(
                    onPressed: () => go(2),
                    icon: Badge(
                      isLabelVisible: cart.itemCount > 0,
                      label: Text('${cart.itemCount}'),
                      child: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ),
              ],
            ),
            body: IndexedStack(
              index: index >= pages.length ? 0 : index,
              children: pages,
            ),
            bottomNavigationBar: AppBottomNav(
              selected: index,
              onChanged: go,
              cartCount: cart.itemCount,
            ),
          ),
        );
      },
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<void> {
  final List products;
  final CartController cart;

  ProductSearchDelegate({required this.products, required this.cart});

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) {
    final q = query.toLowerCase();
    final list = products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.artisan.toLowerCase().contains(q))
        .toList();

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (c, i) => ListTile(
        title: Text(list[i].name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${list[i].category} • By ${list[i].artisan}'),
        trailing: Text(
          '₹${list[i].price}',
          style: const TextStyle(
              fontWeight: FontWeight.w800, color: AppColors.primary),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: list[i], cart: cart),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
