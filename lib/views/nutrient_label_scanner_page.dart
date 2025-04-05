import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrient_scanner/models/nutrient_recognized_text.dart';
import 'package:nutrient_scanner/views/nutrient_intake_guide_page.dart';

part 'nutrient_label_scanner_page.view.dart';

class NutrientLabelScannerPage extends StatefulWidget {
  const NutrientLabelScannerPage({
    super.key,
  });

  @override
  State<NutrientLabelScannerPage> createState() => _NutrientLabelScannerState();
}

class _NutrientLabelScannerState extends State<NutrientLabelScannerPage> {
  final ImagePicker picker = ImagePicker();
  final TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.korean);
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

  Future getImage(ImageSource imageSource) async {
    final pickedImage = await picker.pickImage(source: imageSource);

    if (pickedImage == null) {
      return;
    }

    _recognizeImage(pickedImage);
  }

  void _recognizeImage(XFile image) async {
    setState(() {
      isLoading = true;
    });
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      String text = "";
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          text += "${line.text}\n";
          setState(() {
            recognizedText = NutrientRecognizedText(text);
          });
        }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error recognizing text: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
