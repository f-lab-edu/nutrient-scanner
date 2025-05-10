import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/viewmodel/guide_viewmodel.dart';
import 'package:nutrient_scanner/features/nutrient_scan/model/recognized_text_model.dart';
import 'package:nutrient_scanner/features/nutrient_scan/service/ocr_scan_service.dart';
import 'package:nutrient_scanner/util/error_util.dart';

import '../../barcode_scan/model/barcode_model.dart';
import '../../barcode_scan/service/barcode_cache_service.dart';
import '../../scan_guide/viewmodel/scan_guide_viewmodel.dart';

part '../view/scan_view.dart';

class NutrientLabelScanViewModel extends StatefulWidget {
  final Barcode? barcode;
  const NutrientLabelScanViewModel({
    super.key,
    required this.barcode,
  });

  @override
  State<NutrientLabelScanViewModel> createState() => _NutrientLabelScanState();
}

class _NutrientLabelScanState extends State<NutrientLabelScanViewModel> {
  final OCRScanService _scanService = OCRScanService();
  final BarcodeCacheService _cacheService = BarcodeCacheService();
  NutrientRecognizedText? recognizedText;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Analyze',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _NutrientLabelScanView(
        recognizedText: recognizedText,
        isLoading: isLoading,
        navigateToGuidePage: () => navigateToGuidePage(context),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          onPressed: () => getImage(context),
          label: const Text(
            'Capture',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1AC2A0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> getImage(BuildContext context) async {
    try {
      _setLoading(true);
      await _pickAndProcessImage(context);
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _pickAndProcessImage(BuildContext context) async {
    final pickedImage = await _pickImage(context);
    if (pickedImage == null) return;

    final text = await _processImage(pickedImage.path);
    _updateRecognizedText(text);

    await _cacheService.save(widget.barcode?.value ?? '', text);
    if (context.mounted) {
      _navigateToIntakeGuide(context, text);
    }
  }

  Future<XFile?> _pickImage(BuildContext context) async {
    return await _scanService.pickImage(context);
  }

  Future<String> _processImage(String imagePath) async {
    return await _scanService.recognizeTextFromImage(imagePath);
  }

  void _updateRecognizedText(String text) {
    if (text.isEmpty || text == '') return;
    setState(() {
      recognizedText = NutrientRecognizedText(text);
    });
  }

  void _handleError(Object error) {
    final errorMessage = ErrorUtil.formatErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> loadCachedData(String barcode) async {
    if (barcode.isEmpty) return;

    try {
      final cachedData = await _cacheService.load(barcode);
      if (cachedData != null) {
        _updateRecognizedText(cachedData);
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void navigateToGuidePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanGuideViewModel(),
        fullscreenDialog: true,
      ),
    );
  }

  void _navigateToIntakeGuide(BuildContext context, String cachedData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutrientIntakeGuideViewModel(
          recognizedText: NutrientRecognizedText(cachedData),
        ),
      ),
    );
  }
}
