import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../controllers/artisan_controller.dart';
import '../services/api_client.dart';
import '../services/ai_api_service.dart';
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
  late TextEditingController _materialsController;
  late TextEditingController _tagsController;

  String _selectedCategory = 'Handicrafts';
  String _selectedImageUrl = defaultCategoryImageUrl;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isSaving = false;
  bool _isEditing = false;
  final AiApiService _aiApiService = AiApiService();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.initialProduct != null;
    final p = widget.initialProduct;
    final ai = widget.aiCatalogData;

    _nameController =
        TextEditingController(text: p?.name ?? ai?['title'] ?? '');
    _selectedCategory = p?.category ?? ai?['category'] ?? 'Handicrafts';
    _categoryController = TextEditingController(text: _selectedCategory);
    _priceController = TextEditingController(
        text: p?.price.toString() ?? ai?['price']?.toString() ?? '850');
    _stockController = TextEditingController(
        text: p?.stock.toString() ??
            ai?['quantity']?.toString() ??
            ai?['stock']?.toString() ??
            '15');
    _descriptionController =
        TextEditingController(text: p?.description ?? ai?['description'] ?? '');
    _materialsController = TextEditingController(
      text: p?.materials.join(', ') ??
          (ai?['materials'] as List<dynamic>?)?.join(', ') ??
          '',
    );
    _tagsController = TextEditingController(
      text: p?.tags.join(', ') ??
          (ai?['tags'] as List<String>?)?.join(', ') ??
          'Handmade, Traditional, Local',
    );
    final aiImages = ai?['images'];
    final aiImageUrl = ai?['imageUrl'] ??
        (aiImages is List && aiImages.isNotEmpty ? aiImages.first : '');
    _selectedImageUrl = p?.imageUrl ?? aiImageUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _materialsController.dispose();
    _tagsController.dispose();
    _aiApiService.dispose();
    super.dispose();
  }

  void _runAICataloging() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AICatalogingScreen(
          currentImage: _selectedImageUrl.isEmpty ? null : _selectedImageUrl,
          initialImageBytes: _selectedImageBytes,
          initialImageName: _selectedImageName,
          initialText: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : _nameController.text.trim(),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (result['title'] != null) {
          _nameController.text = result['title'];
        }
        if (result['category'] != null) {
          final category = result['category'].toString();
          final categoryList = categories.map((item) => item.name).toList();
          _selectedCategory =
              categoryList.contains(category) ? category : _selectedCategory;
          _categoryController.text = _selectedCategory;
        }
        if (result['price'] != null) {
          _priceController.text = result['price'].toString();
        }
        if (result['stock'] != null) {
          _stockController.text = result['stock'].toString();
        }
        if (result['description'] != null) {
          _descriptionController.text = result['description'];
        }
        if (result['materials'] != null) {
          final materials = result['materials'] as List<dynamic>;
          _materialsController.text = materials.join(', ');
        }
        if (result['tags'] != null) {
          final tagsList = result['tags'] as List<String>;
          _tagsController.text = tagsList.join(', ');
        }
        if (result['imageUrl'] != null) {
          _selectedImageUrl = result['imageUrl'];
          _selectedImageBytes = null;
        }
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'AI Smart Catalog suggestions applied! Please review & edit below.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final controller = ArtisanController();
      final tags = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final materials = _materialsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final price = int.tryParse(_priceController.text.trim()) ?? 999;
      final stock = int.tryParse(_stockController.text.trim()) ?? 15;
      if (_selectedImageBytes != null && _selectedImageBytes!.isNotEmpty) {
        final uploaded = await _aiApiService.processImage(
          bytes: _selectedImageBytes!,
          filename: _selectedImageName ?? 'product.png',
        );
        _selectedImageUrl = uploaded.imageUrl;
      }

      if (_isEditing && widget.initialProduct != null) {
        final updated = widget.initialProduct!.copyWith(
          name: _nameController.text.trim(),
          category: _selectedCategory,
          price: price,
          description: _descriptionController.text.trim(),
          imageUrl: _selectedImageUrl,
          materials: materials.isNotEmpty
              ? materials
              : widget.initialProduct!.materials,
          tags: tags.isNotEmpty ? tags : widget.initialProduct!.tags,
          stock: stock,
        );
        await controller.updateProduct(updated);
      } else {
        final newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch,
          name: _nameController.text.trim(),
          category: _selectedCategory,
          artisan: controller.artisanName,
          city: controller.artisanCity,
          price: price,
          rating: 0,
          reviews: 0,
          description: _descriptionController.text.trim(),
          imageUrl: _selectedImageUrl,
          materials: materials,
          tags: tags.isNotEmpty ? tags : ['Handmade', _selectedCategory],
          stock: stock,
          featured: true,
        );
        await controller.addProduct(newProduct);
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing
              ? 'Product updated successfully!'
              : 'New product cataloged & saved!'),
          backgroundColor: AppColors.primary,
        ),
      );
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
                    border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          color: AppColors.secondary, size: 24),
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
                              style: TextStyle(
                                  fontSize: 11.5, color: AppColors.textPrimary),
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
                        child: const Text('Try AI',
                            style: TextStyle(fontSize: 12)),
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
                        _selectedImageBytes != null
                            ? Image.memory(_selectedImageBytes!,
                                fit: BoxFit.cover)
                            : (_selectedImageUrl.isNotEmpty
                                ? Image.network(
                                    _selectedImageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40,
                                          color: AppColors.textMuted),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 40,
                                        color: AppColors.textMuted))),
                        Container(color: Colors.black.withValues(alpha: 0.15)),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showImagePickerSheet(context);
                                      },
                                      icon: const Icon(
                                          Icons.photo_library_outlined,
                                          size: 18),
                                      label: const Text('Gallery'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppColors.textPrimary,
                                        minimumSize: const Size(0, 40),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        try {
                                          final file =
                                              await ImagePicker().pickImage(
                                            source: ImageSource.camera,
                                            maxWidth: 2048,
                                            maxHeight: 2048,
                                            imageQuality: 90,
                                          );
                                          if (file == null) return;
                                          final bytes =
                                              await file.readAsBytes();
                                          if (!context.mounted) return;
                                          setState(() {
                                            _selectedImageBytes = bytes;
                                            _selectedImageName = file.name;
                                            _selectedImageUrl = '';
                                          });
                                        } on Exception {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Camera is unavailable on this device.')),
                                            );
                                          }
                                        }
                                      },
                                      icon:
                                          const Icon(Icons.camera_alt_outlined),
                                      label: const Text('Camera'),
                                    ),
                                  ),
                                ],
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
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter product title'
                      : null,
                ),
                const SizedBox(height: 14),

                // Category Dropdown
                const Text(
                  'Category',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: categoryList.contains(_selectedCategory)
                      ? _selectedCategory
                      : categoryList.first,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.grid_view_rounded,
                        color: AppColors.textMuted, size: 20),
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
                        validator: (val) {
                          final value = int.tryParse(val?.trim() ?? '');
                          return value == null || value <= 0
                              ? 'Enter a positive price'
                              : null;
                        },
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
                        validator: (val) {
                          final value = int.tryParse(val?.trim() ?? '');
                          return value == null || value <= 0
                              ? 'Enter a positive quantity'
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText:
                      'Describe materials, craft tradition, size, and care instructions...',
                  maxLines: 4,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter description'
                      : null,
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  controller: _materialsController,
                  labelText: 'Materials (Comma separated)',
                  hintText: 'Natural Clay, Ceramic Glaze',
                  prefixIcon: Icons.category_outlined,
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
                  label: _isEditing
                      ? 'Save Product Changes'
                      : 'Review & Publish Product',
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
              'Select Product Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    final file = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 2048,
                      maxHeight: 2048,
                      imageQuality: 90,
                    );
                    if (file == null) return;
                    final bytes = await file.readAsBytes();
                    if (!context.mounted) return;
                    setState(() {
                      _selectedImageBytes = bytes;
                      _selectedImageName = file.name;
                      _selectedImageUrl = '';
                    });
                  } on Exception {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Unable to read that image. Please choose another file.')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Choose from gallery'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
