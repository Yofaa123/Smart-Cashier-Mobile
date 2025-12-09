import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class BookmarkService {
  Future<List<Map<String, dynamic>>> getSubjectBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/bookmarks/subjects");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }

    throw Exception(data['message'] ?? "Gagal mengambil bookmark pelajaran");
  }

  Future<List<Map<String, dynamic>>> getLessonBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/bookmarks/lessons");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }

    throw Exception(data['message'] ?? "Gagal mengambil bookmark materi");
  }

  Future<Map<String, dynamic>?> addBookmark(
    int? subjectId,
    int? lessonId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/bookmarks");

    final body = subjectId != null
        ? {'subject_id': subjectId}
        : {'lesson_id': lessonId};

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

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data['data'];
    }

    throw Exception(data['message'] ?? "Gagal menambah bookmark");
  }

  Future<bool> removeBookmark(int bookmarkId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/bookmarks/$bookmarkId");

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
