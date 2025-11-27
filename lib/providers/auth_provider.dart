import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? token;
  UserModel? user;

  // ============================================================
  //                        LOGIN
  // ============================================================
  Future<String?> login(String email, String password) async {
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

      return null; // Tidak ada error
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // ============================================================
  //                        REGISTER
  // ============================================================
  Future<String?> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await AuthService().register(
        name,
        email,
        password,
        confirmPassword,
      );

      user = UserModel.fromJson(data['user']);
      token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);

      isLoading = false;
      notifyListeners();

      return null; // sukses -> tidak ada error
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString(); // kirim pesan error ke UI
    }
  }

  // ============================================================
  //                    REQUEST OTP (Forgot Password)
  // ============================================================
  Future<dynamic> requestOtp(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService().requestOtp(email);

      isLoading = false;
      notifyListeners();

      return result; // return Map with debug_otp
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // ============================================================
  //                        VERIFY OTP
  // ============================================================
  Future<String?> verifyOtp(String email, String otp) async {
    isLoading = true;
    notifyListeners();

    try {
      await AuthService().verifyOtp(email, otp);

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // ============================================================
  //                    RESET PASSWORD
  // ============================================================
  Future<String?> resetPassword(
    String email,
    String otp,
    String password,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      await AuthService().resetPassword(email, otp, password);

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // ============================================================
  //                          LOGOUT
  // ============================================================
  Future<void> logout() async {
    user = null;
    token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    notifyListeners();
  }

  // ============================================================
  //                        FETCH PROFILE
  // ============================================================
  Future<String?> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await AuthService().getProfile();

      user = UserModel.fromJson(data['user']);

      isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // ============================================================
  //                      UPDATE PROFILE
  // ============================================================
  Future<String?> updateProfile(
    String name,
    String email,
    String? password,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await AuthService().updateProfile(name, email, password);

      user = UserModel.fromJson(data['user']);

      isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
