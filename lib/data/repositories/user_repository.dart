import 'dart:convert';
import '../models/user_model.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/constants/app_constants.dart';

class UserRepository {
  final SecureStorageService _secureStorageService;
  
  UserRepository(this._secureStorageService);
  
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _secureStorageService.saveUserData(userJson);
    
    if (user.token != null) {
      await _secureStorageService.saveUserToken(user.token!);
    }
  }
  
  Future<UserModel?> getUser() async {
    final userJson = await _secureStorageService.getUserData();
    if (userJson == null) return null;
    
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }
  
  Future<String?> getUserToken() async {
    return await _secureStorageService.getUserToken();
  }
  
  Future<void> deleteUser() async {
    await _secureStorageService.deleteSecureData(AppConstants.userDataKey);
    await _secureStorageService.deleteSecureData(AppConstants.userTokenKey);
  }
  
  Future<void> wipeAllData() async {
    await _secureStorageService.wipeAllSensitiveData();
  }
}