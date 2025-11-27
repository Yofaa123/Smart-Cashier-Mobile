import 'package:flutter/material.dart';
import '../services/favorite_service.dart';

class FavoriteProvider extends ChangeNotifier {
  List favorites = [];
  bool isLoading = false;

  Future<void> fetchFavorites() async {
    isLoading = true;
    notifyListeners();

    try {
      favorites = await FavoriteService().getFavorites();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int lessonId) async {
    final isFav = favorites.any((f) => f['id'] == lessonId);

    try {
      if (isFav) {
        await FavoriteService().removeFavorite(lessonId);
      } else {
        await FavoriteService().addFavorite(lessonId);
      }
      await fetchFavorites(); // Refresh the list
    } catch (e) {
      // Handle error if needed
    }
  }

  bool isFavorite(int lessonId) {
    return favorites.any((f) => f['id'] == lessonId);
  }
}
