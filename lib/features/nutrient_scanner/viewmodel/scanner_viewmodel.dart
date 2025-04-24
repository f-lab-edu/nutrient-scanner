import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/viewmodel/guide_viewmodel.dart';
import 'package:nutrient_scanner/features/nutrient_scanner/model/recognized_text_model.dart';
import 'package:nutrient_scanner/features/nutrient_scanner/service/scanner_service.dart';
import 'package:nutrient_scanner/util/error_util.dart';

part '../view/scanner_view.dart';

class NutrientLabelScannerViewModel extends StatefulWidget {
  const NutrientLabelScannerViewModel({super.key});

  @override
  State<NutrientLabelScannerViewModel> createState() =>
      _NutrientLabelScannerState();
}

class _NutrientLabelScannerState extends State<NutrientLabelScannerViewModel> {
  final ScannerService _scannerService = ScannerService();
  NutrientRecognizedText? recognizedText;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrient Label Scanner'),
      ),
      body: _NutrientLabelScannerView(
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
  }

  Future<XFile?> _pickImage(ImageSource imageSource) async {
    return await _scannerService.pickImage(imageSource);
  }

  Future<String> _processImage(String imagePath) async {
    return await _scannerService.recognizeTextFromImage(imagePath);
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
}
