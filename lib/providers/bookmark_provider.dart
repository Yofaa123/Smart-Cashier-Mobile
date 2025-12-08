import 'package:flutter/material.dart';
import '../models/subject.dart';

class BookmarkProvider extends ChangeNotifier {
  List<SubjectModel> items = [];

  void addBookmark(SubjectModel subject) {
    if (!items.any((item) => item.id == subject.id)) {
      items.add(subject);
      notifyListeners();
    }
  }

  void removeBookmark(int id) {
    items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  bool isBookmarked(int id) {
    return items.any((item) => item.id == id);
  }
}
