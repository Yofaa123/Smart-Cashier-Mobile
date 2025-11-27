import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class LessonService {
  Future<Map<String, dynamic>> getDifficultyPrediction(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/lessons/$lessonId/predict-difficulty",
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message'] ?? "Gagal mengambil prediksi kesulitan");
  }
}
