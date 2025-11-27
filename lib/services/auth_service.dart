import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/login");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      return data;
    }

    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? "Login failed");
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/register");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      return data;
    }

    final errorData = jsonDecode(response.body);

    if (errorData['errors'] != null) {
      final firstKey = errorData['errors'].keys.first;
      final firstMsg = errorData['errors'][firstKey][0];

      throw Exception(firstMsg);
    }

    throw Exception(errorData['message'] ?? "Registration failed");
  }

  Future<void> sendResetPassword(String email) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/forgot-password");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return;
    }

    final data = jsonDecode(response.body);
    throw Exception(data['message'] ?? "Gagal mengirim link reset password");
  }
}
