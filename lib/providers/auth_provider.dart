import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  UserModel? user;
  String? token;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await AuthService().login(email, password);
      user = UserModel.fromJson(data['user']);
      token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await AuthService().register(name, email, password);
      user = UserModel.fromJson(data['user']);
      token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    user = null;
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
