import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiConfig.baseUrl + '/login');
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
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid credentials');
    } else if (response.statusCode == 422) {
      throw Exception('Validation error: Please check your input');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error.toString());
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final url = Uri.parse(ApiConfig.baseUrl + '/register');
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Registration failed');
    } else if (response.statusCode == 422) {
      throw Exception('Validation error: Please check your input');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error.toString());
    }
  }
}
