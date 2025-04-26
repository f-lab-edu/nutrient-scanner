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
    final barcode = await _scanService.scanBarcode(context);
    try {
      if (barcode != null) {
        _updateScannedBarcode(barcode.value);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      ///디버그 모드일 때에는 촬영이 불가능하여 임의의 바코드 값을 설정한다.
      if (kDebugMode) {
        _updateScannedBarcode('1234567890123');
        if (context.mounted) {
          await _checkCachedData(context, scannedBarcode);
        }
      }
    }
  }

  Future<void> _checkCachedData(BuildContext context, String? barcode) async {
    final cachedData = await _cacheService.loadFromCache(barcode ?? '');
    if (context.mounted) {
      if (cachedData != null) {
        _navigateToIntakeGuide(context, cachedData);
      } else {
        _navigateToNutrientScan(context);
      }
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
