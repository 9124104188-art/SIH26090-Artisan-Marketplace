import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../data/catalog.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_drawer.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'product_details_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  final cart = CartController();
  int index = 0;
  late final pages = [
    HomeScreen(onProduct: (p) => openProduct(p), cart: cart),
    CategoryScreen(onProduct: (p) => openProduct(p), cart: cart),
    CartScreen(cart: cart),
    OrdersScreen(onOpenTracking: () => go(3)),
    const ProfileScreen()
  ];
  void go(int i) => setState(() => index = i);
  void openProduct(product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ProductDetailsScreen(product: product, cart: cart)));
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: cart,
      builder: (_, __) => Scaffold(
          drawer: BuyerDrawer(onSelect: (s) {
            Navigator.pop(context);
            if (s == 'Home') go(0);
            if (s == 'Categories') go(1);
            if (s == 'My Cart') go(2);
            if (s == 'My Orders') go(3);
            if (s == 'My Profile') go(4);
          }),
          appBar: AppBar(
              leading: Builder(
                  builder: (c) => IconButton(
                      onPressed: () => Scaffold.of(c).openDrawer(),
                      icon: const Icon(Icons.menu_rounded))),
              title: const Text('Artisan Connect',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: ProductSearchDelegate(
                              products: buildProducts(), cart: cart));
                    },
                    icon: const Icon(Icons.search_rounded)),
                IconButton(
                    onPressed: () => go(2),
                    icon: Badge(
                        isLabelVisible: cart.itemCount > 0,
                        label: Text('${cart.itemCount}'),
                        child: const Icon(Icons.shopping_cart_outlined)))
              ]),
          body: IndexedStack(index: index, children: pages),
          bottomNavigationBar: AppBottomNav(
              selected: index, onChanged: go, cartCount: cart.itemCount)));
}

class ProductSearchDelegate extends SearchDelegate<void> {
  final List products;
  final CartController cart;
  ProductSearchDelegate({required this.products, required this.cart});
  @override
  List<Widget>? buildActions(BuildContext context) =>
      [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));
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
            title: Text(list[i].name),
            subtitle: Text(list[i].category),
            trailing: Text('₹${list[i].price}',
                style: const TextStyle(fontWeight: FontWeight.w800)),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsScreen(product: list[i], cart: cart)))));
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
