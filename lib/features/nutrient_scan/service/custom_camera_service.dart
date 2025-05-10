import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomCameraService extends StatefulWidget {
  const CustomCameraService({super.key});

  @override
  State<CustomCameraService> createState() => _CustomCameraServiceState();
}

class _CustomCameraServiceState extends State<CustomCameraService> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      if (e is CameraException) {
        _handleCameraException(e);
      }
    }
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

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureImage(BuildContext context) async {
    if (kDebugMode) {
      // 디버그 모드에서는 갤러리에서 이미지 선택
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
      }
    } else {
      try {
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          final XFile image = await _cameraController!.takePicture();
          if (context.mounted) {
            setState(() {
              _capturedImage = image;
            });
          }
        }
      } catch (e) {
        debugPrint('Error capturing image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_capturedImage != null) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                File(_capturedImage!.path),
                fit: BoxFit.contain,
              ),
            ),
            _closeButton(context),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(_capturedImage); // 이미지를 반환
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      padding: const EdgeInsets.all(14),
                      height: 48,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF2BC4A6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Analyze',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _capturedImage = null;
                      });
                    },
                    child: const Center(
                      child: Text(
                        'Try again',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2FD7B6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      child: Stack(
        children: [
          // 카메라 프리뷰
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          _closeButton(context),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.50, -0.00),
                  end: const Alignment(0.50, 1.00),
                  colors: [
                    Colors.black.withAlpha(0),
                    Colors.black.withAlpha(225),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // 가이드 문구
          const Positioned(
            left: 0,
            right: 0,
            bottom: 142,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Text(
                'Please take a close photo of the ingredient label to ensure text clarity.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // 촬영 버튼
          Positioned(
            bottom: 58,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: () => _captureImage(context),
                child: Image.asset(
                  'assets/images/camera_button.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Positioned(
      top: 32,
      right: 0,
      child: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
