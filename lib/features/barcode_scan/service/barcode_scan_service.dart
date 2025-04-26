import 'package:flutter/material.dart';
import 'package:nutrient_scanner/features/barcode_scan/model/barcode_model.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeScanService {
  Future<Barcode?> scanBarcode(BuildContext context) async {
    try {
      final String? result = await SimpleBarcodeScanner.scanBarcode(
        context,
        isShowFlashIcon: true,
        delayMillis: 500,
        cameraFace: CameraFace.back,
        scanFormat: ScanFormat.ONLY_BARCODE,
      );

      if (result != null && result.isNotEmpty) {
        final barcode = Barcode(result);
        return barcode.isValid() ? barcode : null;
      }
      return null;
    } catch (e) {
      debugPrint('Error during barcode scanning: $e');
      return null;
    }
  }
}
