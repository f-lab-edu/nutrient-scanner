class Barcode {
  final String value;

  Barcode(String value) : value = value.trim();

  bool isValid() {
    return value.isNotEmpty;
  }

  String formattedValue() {
    return 'Barcode: $value';
  }
}
