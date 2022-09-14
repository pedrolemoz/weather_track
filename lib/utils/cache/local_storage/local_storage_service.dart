import 'package:hive/hive.dart';

import '../exceptions/cache_exception.dart';
import '../keys/cache_keys.dart';
import '../persistent_storage_service.dart';

abstract class LocalStorageService extends PersistentStorageService {}

class LocalStorageServiceImplementation implements LocalStorageService {
  const LocalStorageServiceImplementation();

  @override
  Future<dynamic> getStoredData({String? key}) async {
    if (key == null) throw const CacheException('Invalid key');
    try {
      final box = await Hive.openBox(CacheKeys.appCache);
      final result = await box.get(key);
      if (result != null) {
        return result;
      } else {
        throw const CacheException('Invalid data');
      }
    } catch (exception) {
      throw CacheException(exception.toString());
    }
  }

  @override
  Future<void> storeData({value, String? key}) async {
    if (value == null || key == null) throw const CacheException('Invalid key or value');
    try {
      final box = await Hive.openBox(CacheKeys.appCache);
      await box.put(key, value);
    } catch (exception) {
      throw CacheException(exception.toString());
    }
  }

  @override
  Future<bool> hasStoredDataInKey({String? key}) async {
    if (key == null) return false;
    try {
      final box = await Hive.openBox(CacheKeys.appCache);
      final value = box.containsKey(key);
      return value;
    } catch (exception) {
      return false;
    }
  }

  @override
  Future<void> deleteStoredData({String? key}) async {
    if (key == null) throw const CacheException('Invalid key');
    try {
      final box = await Hive.openBox(CacheKeys.appCache);
      await box.delete(key);
    } catch (exception) {
      throw CacheException(exception.toString());
    }
  }
}
