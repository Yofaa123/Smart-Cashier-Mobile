import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/lesson.dart';
import '../services/bookmark_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final BookmarkService _service = BookmarkService();

  List<SubjectModel> subjectBookmarks = [];
  List<LessonModel> lessonBookmarks = [];
  bool isLoadingSubjects = false;
  bool isLoadingLessons = false;

  Future<void> fetchSubjectBookmarks() async {
    isLoadingSubjects = true;
    notifyListeners();
    try {
      final bookmarks = await _service.getSubjectBookmarks();
      subjectBookmarks = bookmarks.map((json) {
        final subject = SubjectModel.fromJson(json['subject']);
        subject.bookmarkId = json['id'];
        return subject;
      }).toList();
    } catch (e) {
      // Handle error
    }
    isLoadingSubjects = false;
    notifyListeners();
  }

  Future<void> fetchLessonBookmarks() async {
    isLoadingLessons = true;
    notifyListeners();
    try {
      final bookmarks = await _service.getLessonBookmarks();
      lessonBookmarks = bookmarks.map((json) {
        final lesson = LessonModel.fromJson(json['lesson']);
        lesson.bookmarkId = json['id'];
        return lesson;
      }).toList();
    } catch (e) {
      // Handle error
    }
    isLoadingLessons = false;
    notifyListeners();
  }

  Future<void> toggleSubjectBookmark(SubjectModel subject) async {
    final existing = subjectBookmarks.firstWhere(
      (item) => item.id == subject.id,
      orElse: () => SubjectModel(id: -1, name: '', description: ''),
    );

    if (existing.id != -1) {
      // Remove
      if (existing.bookmarkId != null) {
        try {
          await _service.removeBookmark(existing.bookmarkId!);
          subjectBookmarks.removeWhere((item) => item.id == subject.id);
          notifyListeners();
        } catch (e) {
          // Handle error
        }
      }
    } else {
      // Add
      try {
        final bookmarkData = await _service.addBookmark(subject.id, null);
        if (bookmarkData != null) {
          final newSubject = SubjectModel(
            id: subject.id,
            name: subject.name,
            description: subject.description,
            bookmarkId: bookmarkData['id'],
          );
          subjectBookmarks.add(newSubject);
          notifyListeners();
        }
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<void> toggleLessonBookmark(LessonModel lesson) async {
    final existing = lessonBookmarks.firstWhere(
      (item) => item.id == lesson.id,
      orElse: () => LessonModel(
        id: -1,
        subjectId: -1,
        title: '',
        content: '',
        level: '',
        duration: '',
        subjectName: '',
      ),
    );

    if (existing.id != -1) {
      // Remove
      if (existing.bookmarkId != null) {
        try {
          await _service.removeBookmark(existing.bookmarkId!);
          lessonBookmarks.removeWhere((item) => item.id == lesson.id);
          notifyListeners();
        } catch (e) {
          // Handle error
        }
      }
    } else {
      // Add
      try {
        final bookmarkData = await _service.addBookmark(null, lesson.id);
        if (bookmarkData != null) {
          final newLesson = LessonModel(
            id: lesson.id,
            subjectId: lesson.subjectId,
            title: lesson.title,
            content: lesson.content,
            level: lesson.level,
            duration: lesson.duration,
            subjectName: lesson.subjectName,
            bookmarkId: bookmarkData['id'],
          );
          lessonBookmarks.add(newLesson);
          notifyListeners();
        }
      } catch (e) {
        // Handle error
      }
    }
  }

  bool isSubjectBookmarked(int id) {
    return subjectBookmarks.any((item) => item.id == id);
  }

  bool isLessonBookmarked(int id) {
    return lessonBookmarks.any((item) => item.id == id);
  }
}
