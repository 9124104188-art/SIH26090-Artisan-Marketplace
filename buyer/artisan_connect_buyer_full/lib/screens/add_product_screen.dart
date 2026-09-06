import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../controllers/artisan_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../data/catalog.dart';
import 'ai_cataloging_screen.dart';

class AddProductScreen extends StatefulWidget {
  final Product? initialProduct;
  final Map<String, dynamic>? aiCatalogData;

  const AddProductScreen({
    super.key,
    this.initialProduct,
    this.aiCatalogData,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;

  String _selectedCategory = 'Handicrafts';
  String _selectedImageUrl = defaultCategoryImageUrl;
  bool _isSaving = false;
  bool _isEditing = false;

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1493106641515-6b5631de4bb9?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.initialProduct != null;
    final p = widget.initialProduct;
    final ai = widget.aiCatalogData;

    _nameController = TextEditingController(text: p?.name ?? ai?['title'] ?? '');
    _selectedCategory = p?.category ?? ai?['category'] ?? 'Handicrafts';
    _categoryController = TextEditingController(text: _selectedCategory);
    _priceController = TextEditingController(text: p?.price.toString() ?? ai?['price']?.toString() ?? '850');
    _stockController = TextEditingController(text: p?.stock.toString() ?? '15');
    _descriptionController = TextEditingController(
      text: p?.description ?? ai?['description'] ?? 'Authentic handmade product crafted by traditional artisans using sustainable materials.',
    );
    _tagsController = TextEditingController(
      text: p?.tags.join(', ') ?? (ai?['tags'] as List<String>?)?.join(', ') ?? 'Handmade, Traditional, Local',
    );
    _selectedImageUrl = p?.imageUrl ?? ai?['imageUrl'] ?? _sampleImages[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _runAICataloging() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AICatalogingScreen(currentImage: _selectedImageUrl),
      ),
    );

    if (result != null) {
      setState(() {
        if (result['title'] != null) _nameController.text = result['title'];
        if (result['category'] != null) {
          _selectedCategory = result['category'];
          _categoryController.text = result['category'];
        }
        if (result['price'] != null) _priceController.text = result['price'].toString();
        if (result['description'] != null) _descriptionController.text = result['description'];
        if (result['tags'] != null) {
          final tagsList = result['tags'] as List<String>;
          _tagsController.text = tagsList.join(', ');
        }
        if (result['imageUrl'] != null) _selectedImageUrl = result['imageUrl'];
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI Smart Catalog suggestions applied! Please review & edit below.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final controller = ArtisanController();
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (_isEditing && widget.initialProduct != null) {
      final updated = widget.initialProduct!.copyWith(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        price: int.tryParse(_priceController.text.trim()) ?? widget.initialProduct!.price,
        stock: int.tryParse(_stockController.text.trim()) ?? widget.initialProduct!.stock,
        description: _descriptionController.text.trim(),
        imageUrl: _selectedImageUrl,
        tags: tags.isNotEmpty ? tags : widget.initialProduct!.tags,
      );
      controller.updateProduct(updated);
    } else {
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        artisan: controller.artisanName,
        city: controller.artisanCity,
        price: int.tryParse(_priceController.text.trim()) ?? 999,
        rating: 4.8,
        reviews: 1,
        description: _descriptionController.text.trim(),
        imageUrl: _selectedImageUrl,
        tags: tags.isNotEmpty ? tags : ['Handmade', _selectedCategory],
        stock: int.tryParse(_stockController.text.trim()) ?? 15,
        featured: true,
      );
      controller.addProduct(newProduct);
    }

    setState(() => _isSaving = false);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Product updated successfully!' : 'New product cataloged & saved!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = categories.map((c) => c.name).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add New Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Banner Prompt
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: AppColors.secondary, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Smart Cataloging Assistant',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                                color: AppColors.secondary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Auto-generate title, tags, description & market pricing from product photos.',
                              style: TextStyle(fontSize: 11.5, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: _runAICataloging,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('Try AI', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Step 1: Image Upload Area
                const Text(
                  '1. Upload Product Photo',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _selectedImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.image_not_supported_outlined, size: 40, color: AppColors.textMuted),
                          ),
                        ),
                        Container(color: Colors.black.withValues(alpha: 0.15)),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _showImagePickerSheet(context);
                                },
                                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                                label: const Text('Select / Change Photo'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.textPrimary,
                                  minimumSize: const Size(0, 40),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Step 2 & 3: Product Info
                const Text(
                  '2. Product Information',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  controller: _nameController,
                  labelText: 'Product Title',
                  hintText: 'e.g. Handmade Terracotta Lamp',
                  prefixIcon: Icons.shopping_bag_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter product title' : null,
                ),
                const SizedBox(height: 14),

                // Category Dropdown
                const Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: categoryList.contains(_selectedCategory) ? _selectedCategory : categoryList.first,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grid_view_rounded, color: AppColors.textMuted, size: 20),
                  ),
                  items: categoryList.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        labelText: 'Price (₹)',
                        hintText: '850',
                        prefixIcon: Icons.currency_rupee_rounded,
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter price' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _stockController,
                        labelText: 'Stock Units',
                        hintText: '15',
                        prefixIcon: Icons.inventory_rounded,
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter stock' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'Describe materials, craft tradition, size, and care instructions...',
                  maxLines: 4,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter description' : null,
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _tagsController,
                  labelText: 'Tags (Comma separated)',
                  hintText: 'Handmade, Traditional, Eco-friendly',
                  prefixIcon: Icons.label_outlined,
                ),

                const SizedBox(height: 28),

                // Review & Save Action
                CustomButton(
                  label: _isEditing ? 'Save Product Changes' : 'Review & Publish Product',
                  onPressed: _saveProduct,
                  isLoading: _isSaving,
                  icon: Icons.check_circle_outline_rounded,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Product Image Sample',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _sampleImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final img = _sampleImages[i];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageUrl = img;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedImageUrl == img ? AppColors.primary : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(img, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
