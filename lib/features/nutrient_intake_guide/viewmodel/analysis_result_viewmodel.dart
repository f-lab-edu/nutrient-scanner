import '../../../util/cache_manager.dart';
import '../model/analysis_result.dart';

class AnalysisResultViewModel {
  final CacheManager _cacheManager = CacheManager();

  Future<void> saveToCache(String barcode, AnalysisResult result) async {
    final cacheKey = _getCacheKey(barcode);
    await _cacheManager.save(cacheKey, result.answer);
  }

  Future<AnalysisResult?> loadFromCache(String barcode) async {
    final cacheKey = _getCacheKey(barcode);
    final cachedAnswer = await _cacheManager.load(cacheKey);

    if (cachedAnswer != null) {
      return AnalysisResult(cachedAnswer);
    }
    return null;
  }

  String _getCacheKey(String barcode) {
    return barcode;
  }
}
