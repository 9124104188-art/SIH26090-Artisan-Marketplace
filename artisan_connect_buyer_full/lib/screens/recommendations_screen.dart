import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/ai_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

class RecommendationsScreen extends StatefulWidget {
  final ValueChanged<Product> onProduct;
  final List<Product> products;
  final List<Product> preferenceProducts;

  const RecommendationsScreen({
    super.key,
    required this.onProduct,
    required this.products,
    this.preferenceProducts = const [],
  });

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final _aiApiService = AiApiService();
  List<Product> _recommendations = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  @override
  void dispose() {
    _aiApiService.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendations() async {
    if (!mounted) return;
    if (widget.products.isEmpty) {
      setState(() {
        _isLoading = false;
        _recommendations = const [];
        _errorMessage = null;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final suggestions = await _aiApiService.recommendProducts(
        products: widget.products,
        preferenceProducts: widget.preferenceProducts,
      );
      final byId = {
        for (final product in widget.products)
          product.apiId ?? product.id.toString(): product,
      };
      if (!mounted) return;
      setState(() {
        _recommendations = suggestions
            .map((suggestion) => byId[suggestion.productId])
            .whereType<Product>()
            .toList();
        _isLoading = false;
      });
    } on AiApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load recommendations. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommended for You')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _ErrorState(
                  message: _errorMessage!, onRetry: _loadRecommendations)
              : _recommendations.isEmpty
                  ? const Center(
                      child: Text('No recommendations available right now.'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: _recommendations.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: .65,
                      ),
                      itemBuilder: (context, index) {
                        final product = _recommendations[index];
                        return ProductCard(
                          product: product,
                          onTap: () => widget.onProduct(product),
                          onAdd: () => widget.onProduct(product),
                        );
                      },
                    ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 42),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
