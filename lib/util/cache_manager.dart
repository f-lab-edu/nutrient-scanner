import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const _cacheDuration = Duration(days: 7);

  Future<void> save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = DateTime.now().add(_cacheDuration).toIso8601String();

    await prefs.setString(key, value);
    await prefs.setString('${key}_expiry', expiryDate);
  }

  Future<String?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedValue = _getCachedValue(prefs, key);
    final expiryDate = _getExpiryDate(prefs, key);

    if (cachedValue == null || expiryDate == null) {
      return null;
    }
    if (_isExpired(expiryDate)) {
      await _removeKey(prefs, key);
      return null;
    }
    return cachedValue;
  }

  String? _getCachedValue(SharedPreferences prefs, String key) {
    return prefs.getString(key);
  }

  DateTime? _getExpiryDate(SharedPreferences prefs, String key) {
    final expiryDateStr = prefs.getString('${key}_expiry');
    if (expiryDateStr == null) return null;

    try {
      return DateTime.parse(expiryDateStr);
    } catch (_) {
      return null;
    }
  }

  bool _isExpired(DateTime expiryDate) {
    return DateTime.now().isAfter(expiryDate);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await _removeKey(prefs, key);
  }

  Future<void> _removeKey(SharedPreferences prefs, String key) async {
    await prefs.remove(key);
    await prefs.remove('${key}_expiry');
  }
}
