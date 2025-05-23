import 'package:camera/camera.dart';
import 'package:nutrient_scanner/features/nutrient_scan/service/custom_camera_service.dart';

class CustomCameraViewModel {
  final CameraService _cameraService = CameraService();

  CameraController? get cameraController => _cameraService.cameraController;
  XFile? capturedImage;
  bool isLoading = false;

  Future<void> initializeCamera(Function updateState) async {
    isLoading = true;
    updateState();

    await _cameraService.initializeCamera();

    isLoading = false;
    updateState();
  }

  Future<void> captureImage(Function updateState) async {
    capturedImage = await _cameraService.captureImage();
    updateState();
  }

  void resetCapturedImage(Function updateState) {
    capturedImage = null;
    updateState();
  }

  void dispose() {
    _cameraService.dispose();
  }
}
