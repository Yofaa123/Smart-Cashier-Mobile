import 'package:flutter/material.dart';
import '../services/lesson_service.dart';

class LessonProvider extends ChangeNotifier {
  bool isLoadingDifficulty = false;
  String? difficulty;
  double? score;
  String? error;

  Future<void> fetchDifficulty(int lessonId) async {
    isLoadingDifficulty = true;
    error = null;
    notifyListeners();

    try {
      final data = await LessonService().getDifficultyPrediction(lessonId);

      difficulty = data['difficulty'];
      score = data['score']?.toDouble();

      isLoadingDifficulty = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoadingDifficulty = false;
      notifyListeners();
    }
  }

  void reset() {
    difficulty = null;
    score = null;
    error = null;
    isLoadingDifficulty = false;
  }
}
