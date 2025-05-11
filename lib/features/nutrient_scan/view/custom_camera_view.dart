import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutrient_scanner/features/nutrient_scan/viewmodel/custom_camera_viewmodel.dart';

class CustomCameraView extends StatefulWidget {
  const CustomCameraView({super.key});

  @override
  State<CustomCameraView> createState() => _CustomCameraViewState();
}

class _CustomCameraViewState extends State<CustomCameraView> {
  late final CustomCameraViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CustomCameraViewModel();
    _viewModel.initializeCamera(() => setState(() {}));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel.isLoading ||
        _viewModel.cameraController == null ||
        !_viewModel.cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_viewModel.capturedImage != null) {
      return _buildCapturedImageView(context);
    }

    return _buildCameraPreview(context);
  }

  Widget _buildCapturedImageView(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(_viewModel.capturedImage!.path),
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
                    Navigator.of(context).pop(_viewModel.capturedImage);
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
                    _viewModel.resetCapturedImage(() => setState(() {}));
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

  Widget _buildCameraPreview(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_viewModel.cameraController!),
          ),
          _closeButton(context),

          /// 그라데이션
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

          /// 가이드 문구
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
          Positioned(
            bottom: 58,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: () => _viewModel.captureImage(() => setState(() {})),
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
