import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class FavoriteService {
  Future<List> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/favorites");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['favorites'] ?? [];
    }

    throw Exception(data['message'] ?? "Gagal mengambil favorit");
  }

  Future<bool> addFavorite(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/favorites/add");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'lesson_id': lessonId}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> removeFavorite(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/favorites/remove");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'lesson_id': lessonId}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
