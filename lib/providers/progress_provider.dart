import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class ProgressProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> markComplete(int lessonId) async {
    isLoading = true;
    notifyListeners();

    try {
      final success = await ProgressService().markLessonComplete(lessonId);

      isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
