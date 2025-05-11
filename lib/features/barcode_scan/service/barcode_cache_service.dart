import 'package:nutrient_scanner/util/cache_manager.dart';

class BarcodeCacheService {
  final CacheManager _cacheManager = CacheManager();

  Future<void> save(String barcode, String data) async {
    final cacheKey = _getKey(barcode);
    await _cacheManager.save(cacheKey, data);
  }

  Future<String?> load(String barcode) async {
    final cacheKey = _getKey(barcode);
    return await _cacheManager.load(cacheKey);
  }

  String _getKey(String barcode) {
    return barcode;
  }
}
