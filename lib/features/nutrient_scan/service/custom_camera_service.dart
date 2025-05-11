import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  CameraController? get cameraController => _cameraController;

  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
      }
    } catch (e) {
      if (e is CameraException) {
        _handleCameraException(e);
      }
    }
  }

  Future<XFile?> captureImage() async {
    if (kDebugMode) {
      // 디버그 모드에서는 갤러리에서 이미지 선택
      final ImagePicker picker = ImagePicker();
      return await picker.pickImage(source: ImageSource.gallery);
    } else {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        return await _cameraController!.takePicture();
      }
    }
    return null;
  }

  void dispose() {
    _cameraController?.dispose();
  }

  void _handleCameraException(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
        debugPrint('Camera access denied');
        break;
      default:
        debugPrint('Camera error: ${e.description}');
        break;
    }
  }
}
