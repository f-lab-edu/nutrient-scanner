class NutrientRecognizedText {
  final String text;

  NutrientRecognizedText(this.text);

  factory NutrientRecognizedText.fromJson(Map<String, dynamic> json) {
    return NutrientRecognizedText(json['text']);
  }
}
