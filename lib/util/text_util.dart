import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextUtil {
  static String combineRecognizedText(List<TextBlock> blocks) {
    String text = "";
    for (TextBlock block in blocks) {
      for (TextLine line in block.lines) {
        text += "${line.text}\n";
      }
    }
    return text.trim();
  }
}
