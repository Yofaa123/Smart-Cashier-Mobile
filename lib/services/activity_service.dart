import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class ActivityService {
  Future<List<Map<String, dynamic>>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/activities");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }

    throw Exception(data['message'] ?? "Gagal mengambil aktivitas");
  }

  Future<void> logActivity(int subjectId, int lessonId, String action) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("${ApiConfig.baseUrl}/activities");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'subject_id': subjectId,
        'lesson_id': lessonId,
        'action': action,
      }),
    );

    if (response.statusCode != 201) {
      // Log error but don't throw exception to avoid disrupting user experience
      print('Failed to log activity: ${response.statusCode}');
    }
  }
}
