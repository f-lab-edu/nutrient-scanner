import 'package:shared_preferences/shared_preferences.dart';
import '../model/analysis_result.dart';

class AnalysisResultViewModel {
  static const _cacheKey = 'analysis_result_answer';
  static const _cacheDuration = Duration(days: 7);

  /// Save the AnalysisResult to cache
  Future<void> saveToCache(AnalysisResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDate = DateTime.now().add(_cacheDuration).toIso8601String();
    await prefs.setString(_cacheKey, result.answer);
    await prefs.setString('${_cacheKey}_expiry', expiryDate);
  }

  /// Load the AnalysisResult from cache if valid
  Future<AnalysisResult?> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedAnswer = prefs.getString(_cacheKey);
    final expiryDateStr = prefs.getString('${_cacheKey}_expiry');

    if (cachedAnswer != null && expiryDateStr != null) {
      final expiryDate = DateTime.parse(expiryDateStr);
      if (DateTime.now().isBefore(expiryDate)) {
        return AnalysisResult(cachedAnswer);
      } else {
        // Cache expired, clear it
        await prefs.remove(_cacheKey);
        await prefs.remove('${_cacheKey}_expiry');
      }
    }
    return null;
  }
}
