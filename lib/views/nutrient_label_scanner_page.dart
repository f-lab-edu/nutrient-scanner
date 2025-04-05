import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrient_scanner/views/nutrient_intake_guide_page.dart';

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
  String recognizedText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrient Label Scanner'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () => getImage(ImageSource.camera),
                          child: Text('Camera',
                              style:
                                  Theme.of(context).textTheme.headlineMedium)),
                      ElevatedButton(
                          onPressed: () => getImage(ImageSource.gallery),
                          child: Text('Gallery',
                              style:
                                  Theme.of(context).textTheme.headlineMedium)),
                    ],
                  ),
                  recognizedText != ''
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NutrientIntakeGuidePage(
                                    recognizedText: recognizedText),
                              ),
                            );
                          },
                          child: Text('GPT한테 물어보러 가기',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        )
                      : const SizedBox(),
                  Text(
                    'OCR 결과:\n$recognizedText',
                  ),
                ],
              ),
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

      recognizedText = "";

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          setState(() {
            recognizedText += "${line.text}\n";
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
