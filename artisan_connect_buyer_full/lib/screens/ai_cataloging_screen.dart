import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_view.dart';
import '../services/ai_api_service.dart';

class AICatalogingScreen extends StatefulWidget {
  final String? currentImage;
  final Uint8List? initialImageBytes;
  final String? initialImageName;
  final String initialText;

  const AICatalogingScreen({
    super.key,
    this.currentImage,
    this.initialImageBytes,
    this.initialImageName,
    this.initialText = '',
  });

  @override
  State<AICatalogingScreen> createState() => _AICatalogingScreenState();
}

class _AICatalogingScreenState extends State<AICatalogingScreen> {
  late String _selectedImage;
  Uint8List? _imageBytes;
  Uint8List? _originalImageBytes;
  String? _imageName;
  String? _originalImageName;
  bool _isAnalyzing = false;
  bool _isRecording = false;
  bool _isVoiceProcessing = false;
  bool _voiceRetryAvailable = false;
  bool _hasAnalyzed = false;
  String? _errorMessage;
  String _transcription = '';
  final List<Uint8List> _recordingChunks = [];
  StreamSubscription<Uint8List>? _recordingSubscription;
  Completer<void>? _recordingComplete;
  double _suggestedConfidence = 0;
  final AiApiService _aiApiService = AiApiService();
  final AudioRecorder _audioRecorder = AudioRecorder();

  late String _suggestedTitle;
  late String _suggestedCategory;
  late String _suggestedPrice;
  int _suggestedQuantity = 15;
  late List<String> _suggestedTags;
  late String _suggestedDescription;

  String _suggestedCraftType = '';
  List<String> _suggestedMaterials = [];
  final _materialCostController = TextEditingController(text: '0');
  final _labourHoursController = TextEditingController(text: '0');
  final _hourlyRateController = TextEditingController(text: '0');
  final _overheadController = TextEditingController(text: '0');
  final _marginPercentController = TextEditingController(text: '20');
  String _craftComplexity = 'medium';
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _craftTypeController = TextEditingController();
  final _materialsController = TextEditingController();
  final _tagsController = TextEditingController();
  final _priceController = TextEditingController();
  final _transcriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.currentImage ?? '';
    _imageBytes = widget.initialImageBytes;
    _originalImageBytes = widget.initialImageBytes;
    _imageName = widget.initialImageName;
    _originalImageName = widget.initialImageName;
    _suggestedTitle = '';
    _suggestedCategory = '';
    _suggestedPrice = '';
    _suggestedTags = [];
    _suggestedDescription = widget.initialText;
  }

  @override
  void dispose() {
    _materialCostController.dispose();
    _labourHoursController.dispose();
    _hourlyRateController.dispose();
    _overheadController.dispose();
    _marginPercentController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _craftTypeController.dispose();
    _materialsController.dispose();
    _tagsController.dispose();
    _priceController.dispose();
    _transcriptionController.dispose();
    unawaited(_recordingSubscription?.cancel());
    unawaited(_audioRecorder.dispose());
    _aiApiService.dispose();
    super.dispose();
  }

  double _pricingValue(TextEditingController controller, double fallback) {
    return double.tryParse(controller.text.trim()) ?? fallback;
  }

  Future<PricingSuggestion> _predictPrice() {
    return _aiApiService.predictPrice(
      materialCost: _pricingValue(_materialCostController, 0),
      labourHours: _pricingValue(_labourHoursController, 0),
      hourlyRate: _pricingValue(_hourlyRateController, 0),
      overhead: _pricingValue(_overheadController, 0),
      marginPercent: _pricingValue(_marginPercentController, 20),
      craftComplexity: _craftComplexity,
    );
  }

  Future<void> _pickImage() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
        _originalImageBytes = bytes;
        _imageName = file.name;
        _originalImageName = file.name;
        _selectedImage = '';
        _hasAnalyzed = false;
        _errorMessage = null;
      });
    } on Exception {
      if (mounted) {
        setState(() => _errorMessage =
            'Unable to read that image. Please choose another file.');
      }
    }
  }

  void _startAIAnalysis() async {
    final imageBytes = _imageBytes ?? _originalImageBytes;
    if (imageBytes == null || imageBytes.isEmpty) {
      setState(
          () => _errorMessage = 'Select a product image before analyzing.');
      return;
    }
    final sourceText = _suggestedDescription.trim();
    setState(() {
      _isAnalyzing = true;
      _hasAnalyzed = false;
      _errorMessage = null;
    });

    try {
      final processed = await _aiApiService.processImage(
        bytes: imageBytes,
        filename: _imageName ?? _originalImageName ?? 'product.png',
      );
      final suggestion = await _aiApiService.generateCatalog(
        text: sourceText.isEmpty ? 'Handmade artisan product' : sourceText,
        imageUrl: processed.imageUrl,
      );
      final pricing = await _predictPrice();

      if (!mounted) return;

      setState(() {
        _isAnalyzing = false;
        _hasAnalyzed = true;
        _suggestedTitle = suggestion.title;
        _suggestedCategory = suggestion.category;
        _suggestedTags = suggestion.tags;
        _suggestedDescription = suggestion.description;
        _suggestedCraftType = suggestion.craftType;
        _suggestedMaterials = suggestion.materials;
        _suggestedConfidence = suggestion.confidence ?? 0;
        _suggestedPrice = pricing.suggestedPrice.toString();
        _suggestedQuantity = suggestion.quantity ?? 15;
        _selectedImage = processed.imageUrl;
        _imageBytes = null;
        _titleController.text = _suggestedTitle;
        _descriptionController.text = _suggestedDescription;
        _categoryController.text = _suggestedCategory;
        _craftTypeController.text = _suggestedCraftType;
        _materialsController.text = _suggestedMaterials.join(', ');
        _tagsController.text = _suggestedTags.join(', ');
        _priceController.text = _suggestedPrice;
      });
    } on AiApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _errorMessage = error.message;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'AI analysis failed. Please try again.';
      });
    }
  }

  Future<void> _toggleVoiceCataloging() async {
    if (_isRecording) {
      await _stopVoiceRecording();
      return;
    }

    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        setState(() => _errorMessage =
            'Microphone permission is required to record a product description.');
        return;
      }
      _recordingChunks.clear();
      _recordingComplete = Completer<void>();
      final stream = await _audioRecorder.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ));
      _recordingSubscription = stream.listen(
        _recordingChunks.add,
        onDone: () {
          if (!(_recordingComplete?.isCompleted ?? true)) {
            _recordingComplete!.complete();
          }
        },
      );
      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _voiceRetryAvailable = true;
        _errorMessage = null;
        _transcription = '';
      });
    } on Exception {
      if (mounted) {
        setState(() => _errorMessage =
            'Unable to start recording. Check microphone permission and try again.');
      }
    }
  }

  Future<void> _stopVoiceRecording() async {
    try {
      await _audioRecorder.stop();
      await _recordingComplete?.future.timeout(const Duration(seconds: 3));
      final subscription = _recordingSubscription;
      _recordingSubscription = null;
      await subscription?.cancel();
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        _isVoiceProcessing = true;
        _errorMessage = null;
      });
      final transcription = await _aiApiService.transcribeAudio(
        bytes: _pcmToWav(_joinBytes(_recordingChunks)),
        filename: 'voice.wav',
      );
      await _applyCatalogFromText(transcription);
    } on TimeoutException {
      _showVoiceError('Recording did not finish. Please try again.');
    } on AiApiException catch (error) {
      _showVoiceError(error.message);
    } on Exception {
      _showVoiceError('Voice cataloging failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isVoiceProcessing = false);
    }
  }

  Future<void> _applyCatalogFromText(String text) async {
    ImageProcessResult? processed;
    final imageBytes = _imageBytes ?? _originalImageBytes;
    if (imageBytes != null && imageBytes.isNotEmpty) {
      processed = await _aiApiService.processImage(
        bytes: imageBytes,
        filename: _imageName ?? _originalImageName ?? 'product.png',
      );
    }
    final suggestion = await _aiApiService.generateCatalog(
      text: text,
      imageUrl: processed?.imageUrl,
    );
    final pricing = await _predictPrice();
    if (!mounted) return;
    setState(() {
      _transcription = text;
      _transcriptionController.text = text;
      _hasAnalyzed = true;
      _suggestedTitle = suggestion.title;
      _suggestedCategory = suggestion.category;
      _suggestedTags = suggestion.tags;
      _suggestedDescription = suggestion.description;
      _suggestedCraftType = suggestion.craftType;
      _suggestedMaterials = suggestion.materials;
      _suggestedConfidence = suggestion.confidence ?? 0;
      _suggestedPrice = pricing.suggestedPrice.toString();
      _suggestedQuantity = suggestion.quantity ?? 15;
      if (processed != null) {
        _selectedImage = processed.imageUrl;
        _imageBytes = null;
      }
      _titleController.text = _suggestedTitle;
      _descriptionController.text = _suggestedDescription;
      _categoryController.text = _suggestedCategory;
      _craftTypeController.text = _suggestedCraftType;
      _materialsController.text = _suggestedMaterials.join(', ');
      _tagsController.text = _suggestedTags.join(', ');
      _priceController.text = _suggestedPrice;
    });
  }

  Future<void> _regenerateFromEditedTranscription() async {
    final text = _transcriptionController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _isVoiceProcessing = true;
      _errorMessage = null;
    });
    try {
      await _applyCatalogFromText(text);
    } on AiApiException catch (error) {
      _showVoiceError(error.message);
    } on Object {
      _showVoiceError('Unable to regenerate the catalog. Please try again.');
    } finally {
      if (mounted) setState(() => _isVoiceProcessing = false);
    }
  }

  Uint8List _joinBytes(List<Uint8List> chunks) {
    final length = chunks.fold<int>(0, (total, chunk) => total + chunk.length);
    final bytes = Uint8List(length);
    var offset = 0;
    for (final chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return bytes;
  }

  Uint8List _pcmToWav(Uint8List pcm) {
    final bytes = ByteData(44 + pcm.length);
    bytes.setUint32(0, 0x52494646, Endian.big);
    bytes.setUint32(4, 36 + pcm.length, Endian.little);
    bytes.setUint32(8, 0x57415645, Endian.big);
    bytes.setUint32(12, 0x666d7420, Endian.big);
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, 1, Endian.little);
    bytes.setUint32(24, 16000, Endian.little);
    bytes.setUint32(28, 32000, Endian.little);
    bytes.setUint16(32, 2, Endian.little);
    bytes.setUint16(34, 16, Endian.little);
    bytes.setUint32(36, 0x64617461, Endian.big);
    bytes.setUint32(40, pcm.length, Endian.little);
    bytes.buffer.asUint8List(44).setAll(0, pcm);
    return bytes.buffer.asUint8List();
  }

  void _showVoiceError(String message) {
    if (!mounted) return;
    setState(() {
      _isRecording = false;
      _isVoiceProcessing = false;
      _errorMessage = message;
    });
  }

  void _acceptCatalog() {
    final result = {
      'title': _titleController.text.trim(),
      'category': _categoryController.text.trim(),
      'price': _priceController.text.trim(),
      'tags': _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(),
      'description': _descriptionController.text.trim(),
      'craftType': _craftTypeController.text.trim(),
      'materials': _materialsController.text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(),
      'quantity': _suggestedQuantity,
      'stock': _suggestedQuantity,
      'imageUrl': _selectedImage,
      'images': _selectedImage.isEmpty ? <String>[] : [_selectedImage],
      'transcription': _transcription,
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
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        color: AppColors.primary, size: 24),
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

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          _isVoiceProcessing ? null : _toggleVoiceCataloging,
                      icon: Icon(_isRecording
                          ? Icons.stop_rounded
                          : Icons.mic_none_rounded),
                      label: Text(_isRecording
                          ? 'Stop & Catalog Voice'
                          : 'Catalog by Voice'),
                    ),
                  ),
                ],
              ),
              if (_isVoiceProcessing) ...[
                const SizedBox(height: 10),
                const LinearProgressIndicator(),
                const SizedBox(height: 6),
                const Text('Transcribing voice and generating a catalog...'),
              ],
              if (_transcription.isNotEmpty) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _transcriptionController,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Transcription (editable)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: _isVoiceProcessing
                        ? null
                        : _regenerateFromEditedTranscription,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Regenerate fields'),
                  ),
                ),
              ],

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
                  child: _imageBytes != null
                      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                      : (_selectedImage.isNotEmpty
                          ? Image.network(_selectedImage, fit: BoxFit.cover)
                          : const Center(
                              child: Text('Select a product image'))),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(_imageBytes == null
                          ? 'Select Photo'
                          : 'Replace Photo'),
                    ),
                  ),
                  if (_imageBytes != null) ...[
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Remove photo',
                      onPressed: () => setState(() {
                        _imageBytes = null;
                        _originalImageBytes = null;
                        _imageName = null;
                        _originalImageName = null;
                        _selectedImage = '';
                        _hasAnalyzed = false;
                      }),
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _materialCostController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Material cost (optional)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _labourHoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Labour hours',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Hourly rate',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _overheadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Overhead',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _marginPercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Margin percent',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                initialValue: _craftComplexity,
                decoration: const InputDecoration(
                  labelText: 'Craft complexity',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'simple', child: Text('Simple')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'complex', child: Text('Complex')),
                  DropdownMenuItem(
                      value: 'high_mastery', child: Text('High mastery')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _craftComplexity = value);
                  }
                },
              ),

              const SizedBox(height: 12),

              // Analyze Button, loading, error, or results
              if (!_isAnalyzing && !_hasAnalyzed && _errorMessage == null) ...[
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
                    message:
                        'AI Vision is analyzing craft patterns, material, and regional attributes...\nEstimating market value...',
                  ),
                ),
              ] else if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.red),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error_outline_rounded,
                              color: AppColors.red),
                          SizedBox(width: 8),
                          Text('AI analysis failed',
                              style: TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_errorMessage!),
                      const SizedBox(height: 14),
                      CustomButton(
                        label: 'Try Again',
                        onPressed: _voiceRetryAvailable
                            ? _toggleVoiceCataloging
                            : _startAIAnalysis,
                        type: ButtonType.outline,
                        icon: Icons.refresh_rounded,
                      ),
                    ],
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: AppColors.primary, size: 16),
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
                            'Confidence: ${(_suggestedConfidence * 100).round()}%',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                            labelText: 'AI title suggestion'),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _categoryController,
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'AI suggested price (editable)',
                          prefixText: '₹ ',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _craftTypeController,
                        decoration:
                            const InputDecoration(labelText: 'Craft type'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _materialsController,
                        decoration: const InputDecoration(
                            labelText: 'Materials (comma separated)'),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tags (editable):',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _tagsController,
                        decoration: const InputDecoration(
                          hintText: 'handmade, traditional, local',
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'AI description (editable):',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _descriptionController,
                        minLines: 4,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
