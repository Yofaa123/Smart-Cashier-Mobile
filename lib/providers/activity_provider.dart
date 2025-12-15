import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityService _service = ActivityService();

  List<ActivityModel> activities = [];
  bool isLoading = false;

  Future<void> fetchActivities() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _service.getActivities();
      activities = data.map((json) => ActivityModel.fromJson(json)).toList();
    } catch (e) {
      // Handle error
      activities = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logActivity(String action, int lessonId, int subjectId) async {
    await _service.logActivity(subjectId, lessonId, action);
  }
}
