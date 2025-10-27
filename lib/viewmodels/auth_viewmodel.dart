import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';
import '../core/services/notification_service.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final NotificationService _notificationService;
  final Logger _logger = Logger();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDataWiped = false;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isDataWiped => _isDataWiped;
  
  AuthViewModel(this._userRepository, this._notificationService) {
    _notificationService.registerDataWipedCallback(_onDataWiped);
    _loadUser();
  }
  
  Future<void> _loadUser() async {
    _currentUser = await _userRepository.getUser();
    notifyListeners();
  }
  
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final user = UserModel(
        id: '123',
        email: email,
        name: 'Usuario Demo',
        token: 'sample_token_12345',
      );
      
      await _userRepository.saveUser(user);
      _currentUser = user;
      
      _logger.i('Login exitoso para: $email');
    } catch (e) {
      _errorMessage = 'Error en el login';
      _logger.e('Error en login: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _userRepository.deleteUser();
      _currentUser = null;
      _logger.i('Logout exitoso');
    } catch (e) {
      _logger.e('Error en logout: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  void _onDataWiped() {
    _logger.w('Callback: Datos eliminados remotamente');
    _currentUser = null;
    _isDataWiped = true;
    notifyListeners();
  }
  
  void resetDataWipedFlag() {
    _isDataWiped = false;
    notifyListeners();
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _notificationService.unregisterDataWipedCallback(_onDataWiped);
    super.dispose();
  }
}