import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_view.dart';

class AICatalogingScreen extends StatefulWidget {
  final String? currentImage;

  const AICatalogingScreen({
    super.key,
    this.currentImage,
  });

  @override
  State<AICatalogingScreen> createState() => _AICatalogingScreenState();
}

class _AICatalogingScreenState extends State<AICatalogingScreen> {
  late String _selectedImage;
  bool _isAnalyzing = false;
  bool _hasAnalyzed = false;

  late String _suggestedTitle;
  late String _suggestedCategory;
  late String _suggestedPrice;
  late List<String> _suggestedTags;
  late String _suggestedDescription;

  final List<Map<String, dynamic>> _aiSamplePresets = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
      'title': 'Traditional Handmade Palm Leaf Basket',
      'category': 'Handicrafts',
      'price': '650',
      'tags': ['Handmade', 'Eco-Friendly', 'Natural Fiber', 'Traditional'],
      'description': 'Woven with natural palm leaves using century-old techniques. Durable, lightweight, and perfect for eco-conscious home decor or storage.',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
      'title': 'Handcrafted Terracotta Earthen Diya Set',
      'category': 'Home Decor',
      'price': '480',
      'tags': ['Terracotta', 'Clay Craft', 'Festive', 'Local Artisan'],
      'description': 'Artisanal earthenware crafted from pure natural riverbed clay. Hand-painted with non-toxic organic colors by Thanjavur craftspersons.',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=800&q=80',
      'title': 'Antique Oxidised Silver Jhumka Earrings',
      'category': 'Jewellery',
      'price': '890',
      'tags': ['Oxidised Silver', 'Jhumka', 'Ethnic', 'Handmade'],
      'description': 'Intricately designed handmade brass & silver alloy jhumkas featuring classic bell motifs crafted by rural metal artisans.',
    },
  ];

  int _selectedPresetIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.currentImage ?? _aiSamplePresets[0]['imageUrl'];
    _loadPresetData(0);
  }

  void _loadPresetData(int index) {
    final data = _aiSamplePresets[index];
    _selectedPresetIndex = index;
    _selectedImage = data['imageUrl'];
    _suggestedTitle = data['title'];
    _suggestedCategory = data['category'];
    _suggestedPrice = data['price'];
    _suggestedTags = List<String>.from(data['tags']);
    _suggestedDescription = data['description'];
  }

  void _startAIAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _hasAnalyzed = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isAnalyzing = false;
      _hasAnalyzed = true;
    });
  }

  void _acceptCatalog() {
    final result = {
      'title': _suggestedTitle,
      'category': _suggestedCategory,
      'price': _suggestedPrice,
      'tags': _suggestedTags,
      'description': _suggestedDescription,
      'imageUrl': _selectedImage,
    };
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('AI Smart Cataloging'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Computer Vision & NLP AI analyzes your product photo to auto-generate title, tags, and market prices.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Image Box
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(_selectedImage, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 14),

              // Preset switcher
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _aiSamplePresets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    return ChoiceChip(
                      label: Text('Sample Craft ${i + 1}'),
                      selected: _selectedPresetIndex == i,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _loadPresetData(i);
                            _hasAnalyzed = false;
                          });
                        }
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Analyze Button or Loading or Results
              if (!_isAnalyzing && !_hasAnalyzed) ...[
                CustomButton(
                  label: 'Analyze Product with AI',
                  onPressed: _startAIAnalysis,
                  icon: Icons.auto_awesome_rounded,
                  type: ButtonType.secondary,
                ),
              ] else if (_isAnalyzing) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const LoadingView(
                    message: 'AI Vision is analyzing craft patterns, material, and regional attributes...\nEstimating market value...',
                  ),
                ),
              ] else if (_hasAnalyzed) ...[
                // AI Results View
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'AI Catalog Suggestion',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Confidence: 96%',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Text(
                        _suggestedTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Chip(
                            label: Text('Category: $_suggestedCategory'),
                            backgroundColor: AppColors.primarySoft,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text('Suggested Price: ₹$_suggestedPrice'),
                            backgroundColor: AppColors.secondarySoft,
                            labelStyle: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        'Tags Detected:',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _suggestedTags
                            .map((t) => Chip(
                                  label: Text(t),
                                  backgroundColor: const Color(0xFFF2F4F3),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'AI Generated Description:',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _suggestedDescription,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Re-Analyze',
                        onPressed: _startAIAnalysis,
                        type: ButtonType.outline,
                        icon: Icons.refresh_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        label: 'Accept & Apply',
                        onPressed: _acceptCatalog,
                        type: ButtonType.primary,
                        icon: Icons.check_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
