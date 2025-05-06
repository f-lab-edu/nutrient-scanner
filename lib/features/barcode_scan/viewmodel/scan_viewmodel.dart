import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nutrient_scanner/features/barcode_scan/model/barcode_model.dart';
import 'package:nutrient_scanner/features/barcode_scan/service/barcode_cache_service.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/viewmodel/guide_viewmodel.dart';
import 'package:nutrient_scanner/util/error_util.dart';

import '../../nutrient_scan/model/recognized_text_model.dart';
import '../../nutrient_scan/viewmodel/scan_viewmodel.dart';
import '../service/barcode_scan_service.dart';

part '../view/scan_view.dart';

class BarcodeScanViewModel extends StatefulWidget {
  const BarcodeScanViewModel({super.key});

  @override
  State<BarcodeScanViewModel> createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScanViewModel> {
  final BarcodeScanService _scanService = BarcodeScanService();
  final BarcodeCacheService _cacheService = BarcodeCacheService();
  String? scannedBarcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Label Scan'),
      ),
      body: _BarcodeScanView(
        onScanButtonPressed: () => startBarcodeScan(context),
      ),
    );
  }

  Future<void> startBarcodeScan(BuildContext context) async {
    try {
      final barcode = await _performBarcodeScan(context);
      if (barcode != null && context.mounted) {
        await _handleScannerBarcode(context, barcode.value);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      if (context.mounted) {
        await _checkDebugModeCachedData(context);
      }
    }
  }

  Future<Barcode?> _performBarcodeScan(BuildContext context) async {
    return await _scanService.scanBarcode(context);
  }

  Future<void> _handleScannerBarcode(
      BuildContext context, String barcodeValue) async {
    _updateScannedBarcode(barcodeValue);
    if (context.mounted) {
      await _checkCachedData(context, barcodeValue);
    }
  }

  Future<void> _checkDebugModeCachedData(BuildContext context) async {
    if (kDebugMode) {
      _setDebugBarcodeTemp();
    }

    await _checkCachedData(context, scannedBarcode ?? '');
  }

  void _setDebugBarcodeTemp() {
    _updateScannedBarcode('1234567890123');
  }

  Future<void> _checkCachedData(BuildContext context, String? barcode) async {
    final cachedData = await _cacheService.load(barcode ?? '');
    if (!context.mounted) return;
    if (cachedData != null) {
      _navigateToIntakeGuide(context, cachedData);
    } else {
      _navigateToNutrientScan(context);
    }
  }

  void _updateScannedBarcode(String barcode) {
    setState(() {
      scannedBarcode = barcode;
    });
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

  void _navigateToNutrientScan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NutrientLabelScanViewModel(
          barcode: Barcode(scannedBarcode ?? ''),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _handleError(Object error) {
    final errorMessage = ErrorUtil.formatErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
