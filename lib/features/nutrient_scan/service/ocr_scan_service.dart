import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrient_scanner/util/text_util.dart';

class OCRScanService {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.korean);

  Future<XFile?> pickImage(ImageSource source) async {
    return await _picker.pickImage(source: source);
  }

  Future<String> recognizeTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      return TextUtil.combineRecognizedText(recognizedText.blocks);
    } catch (e) {
      throw Exception('OCR 처리 중 에러 발생: $e');
    } finally {
      _textRecognizer.close();
    }
  }
}
