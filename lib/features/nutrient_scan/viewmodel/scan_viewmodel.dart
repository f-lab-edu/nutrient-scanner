import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/viewmodel/guide_viewmodel.dart';
import 'package:nutrient_scanner/features/nutrient_scan/model/recognized_text_model.dart';
import 'package:nutrient_scanner/features/nutrient_scan/service/ocr_scan_service.dart';
import 'package:nutrient_scanner/util/error_util.dart';

import '../../barcode_scan/model/barcode_model.dart';
import '../../barcode_scan/service/barcode_cache_service.dart';

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
        title: const Text('Nutrient Label Scan'),
      ),
      body: _NutrientLabelScanView(
        recognizedText: recognizedText,
        isLoading: isLoading,
        getImage: getImage,
      ),
    );
  }

  Future<void> getImage(ImageSource imageSource) async {
    try {
      _setLoading(true);
      await _pickAndProcessImage(imageSource);
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _pickAndProcessImage(ImageSource imageSource) async {
    final pickedImage = await _pickImage(imageSource);
    if (pickedImage == null) return;

    final text = await _processImage(pickedImage.path);
    _updateRecognizedText(text);

    await _cacheService.saveToCache(widget.barcode?.value ?? '', text);
  }

  Future<XFile?> _pickImage(ImageSource imageSource) async {
    return await _scanService.pickImage(imageSource);
  }

  Future<String> _processImage(String imagePath) async {
    return await _scanService.recognizeTextFromImage(imagePath);
  }

  void _updateRecognizedText(String text) {
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
    try {
      final cachedData = await _cacheService.loadFromCache(barcode);
      if (cachedData != null) {
        _updateRecognizedText(cachedData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No cached data found for this barcode.')),
        );
      }
    } catch (e) {
      _handleError(e);
    }
  }
}
