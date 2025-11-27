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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    }

    throw Exception(data['message'] ?? "Login gagal");
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data;
    }

    if (data['errors'] != null) {
      final firstKey = data['errors'].keys.first;
      final firstMsg = data['errors'][firstKey][0];
      throw Exception(firstMsg);
    }

    throw Exception(data['message'] ?? "Registration failed");
  }

  // ============================================================
  //                PERBAIKAN DI SINI (PENTING)
  // ============================================================
  Future<Map<String, dynamic>> requestOtp(String email) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/forgot-password/request-otp");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data; // <-- return MAP termasuk debug_otp
    }

    throw Exception(data["message"] ?? "Gagal mengirim OTP");
  }

  Future<void> verifyOtp(String email, String otp) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/forgot-password/verify-otp");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "OTP salah");
    }
  }

  Future<void> resetPassword(String email, String otp, String password) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/forgot-password/reset");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Gagal reset password");
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/profile");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message'] ?? "Gagal mengambil profil");
  }

  Future<Map<String, dynamic>> updateProfile(
    String name,
    String email,
    String? password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/profile/update");

    final body = {'name': name, 'email': email};

    if (password != null && password.isNotEmpty) {
      body['password'] = password;
      body['password_confirmation'] = password;
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message'] ?? "Gagal update profil");
  }
}
