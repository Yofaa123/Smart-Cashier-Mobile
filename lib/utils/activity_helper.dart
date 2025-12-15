import 'package:flutter/material.dart';

String activityTitle(String type) {
  switch (type) {
    case 'read_material':
    case 'read_lesson':
      return 'Membaca materi';
    case 'open_lesson':
      return 'Membuka pelajaran';
    case 'complete_lesson':
      return 'Menyelesaikan pelajaran';
    default:
      return 'Aktivitas';
  }
}

IconData activityIcon(String type) {
  switch (type) {
    case 'read_lesson':
      return Icons.menu_book;
    case 'open_lesson':
      return Icons.folder_open;
    case 'complete_lesson':
      return Icons.check_circle;
    default:
      return Icons.history;
  }
}
