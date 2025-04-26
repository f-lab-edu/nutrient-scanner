import 'package:nutrient_scanner/util/cache_manager.dart';

class BarcodeCacheService {
  final CacheManager _cacheManager = CacheManager();

  Future<void> saveToCache(String barcode, String data) async {
    final cacheKey = _getCacheKey(barcode);
    await _cacheManager.saveToCache(cacheKey, data);
  }

  Future<String?> loadFromCache(String barcode) async {
    final cacheKey = _getCacheKey(barcode);
    return await _cacheManager.loadFromCache(cacheKey);
  }

  String _getCacheKey(String barcode) {
    return barcode;
  }
}
