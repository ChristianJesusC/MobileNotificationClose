import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();
  
  Future<void> saveSecureData(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      _logger.i('Dato guardado de forma segura: $key');
    } catch (e) {
      _logger.e('Error guardando dato seguro: $e');
    }
  }
  
  Future<String?> getSecureData(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      _logger.e('Error leyendo dato seguro: $e');
      return null;
    }
  }
  
  Future<void> deleteSecureData(String key) async {
    try {
      await _secureStorage.delete(key: key);
      _logger.i('Dato seguro eliminado: $key');
    } catch (e) {
      _logger.e('Error eliminando dato seguro: $e');
    }
  }
  
  Future<void> wipeAllSecureData() async {
    try {
      await _secureStorage.deleteAll();
      _logger.w('Todos los datos seguros eliminados');
    } catch (e) {
      _logger.e('Error limpiando datos seguros: $e');
    }
  }
  
  Future<void> wipeAllSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _logger.w('SharedPreferences limpiado');
    } catch (e) {
      _logger.e('Error limpiando SharedPreferences: $e');
    }
  }
  
  Future<void> wipeAllSensitiveData() async {
    _logger.w('Iniciando eliminacion de datos sensibles...');
    
    await deleteSecureData(AppConstants.userTokenKey);
    await deleteSecureData(AppConstants.userDataKey);
    await deleteSecureData(AppConstants.userEmailKey);
    await deleteSecureData(AppConstants.userPasswordKey);
    await deleteSecureData(AppConstants.sensitiveDataKey);
    
    await wipeAllSecureData();
    
    await wipeAllSharedPreferences();
    
    _logger.w('Eliminacion de datos sensibles completada');
  }
  
  Future<void> saveUserToken(String token) async {
    await saveSecureData(AppConstants.userTokenKey, token);
  }
  
  Future<String?> getUserToken() async {
    return await getSecureData(AppConstants.userTokenKey);
  }
  
  Future<void> saveUserData(String userData) async {
    await saveSecureData(AppConstants.userDataKey, userData);
  }
  
  Future<String?> getUserData() async {
    return await getSecureData(AppConstants.userDataKey);
  }
}