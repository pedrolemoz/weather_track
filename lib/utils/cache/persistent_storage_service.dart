abstract class PersistentStorageService {
  const PersistentStorageService();

  Future<void> storeData({dynamic value, String? key});
  Future<dynamic> getStoredData({String? key});
  Future<bool> hasStoredDataInKey({String? key});
  Future<void> deleteStoredData({String? key});
}
