import 'package:flutter/material.dart';
import '../services/gamification_service.dart';

class GamificationProvider extends ChangeNotifier {
  int level = 0;
  int xp = 0;
  int maxXp = 100;
  List badges = [];
  bool isLoading = false;

  Future<void> fetchStatus() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await GamificationService().getStatus();
      level = data['level'] ?? 0;
      xp = data['xp'] ?? 0;
      maxXp = data['max_xp'] ?? 100;
      badges = data['badges'] ?? [];
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
}
