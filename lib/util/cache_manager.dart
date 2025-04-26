import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const _cacheDuration = Duration(days: 7);

  Future<void> saveToCache(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = DateTime.now().add(_cacheDuration).toIso8601String();

    await prefs.setString(key, value);
    await prefs.setString('${key}_expiry', expiryDate);
  }

  Future<String?> loadFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedValue = prefs.getString(key);
    final expiryDateStr = prefs.getString('${key}_expiry');

    if (cachedValue != null && expiryDateStr != null) {
      final expiryDate = DateTime.parse(expiryDateStr);
      if (DateTime.now().isBefore(expiryDate)) {
        return cachedValue;
      } else {
        // Remove expired cache
        await prefs.remove(key);
        await prefs.remove('${key}_expiry');
      }
    }
    return null;
  }

  Future<void> removeFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.remove('${key}_expiry');
  }
}
