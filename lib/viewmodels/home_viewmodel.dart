import 'package:flutter/material.dart';
import '../data/repositories/user_repository.dart';
import '../data/models/user_model.dart';

class HomeViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  
  UserModel? _user;
  List<String> _sensitiveDataList = [];
  
  UserModel? get user => _user;
  List<String> get sensitiveDataList => _sensitiveDataList;
  
  HomeViewModel(this._userRepository) {
    _loadData();
  }
  
  Future<void> _loadData() async {
    _user = await _userRepository.getUser();
    _sensitiveDataList = [
      'Dato confidencial 1',
      'Dato confidencial 2',
      'Dato confidencial 3',
    ];
    notifyListeners();
  }
  
  void addSensitiveData(String data) {
    _sensitiveDataList.add(data);
    notifyListeners();
  }
  
  Future<void> refresh() async {
    await _loadData();
  }
}