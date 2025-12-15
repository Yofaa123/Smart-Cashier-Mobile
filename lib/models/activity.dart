import 'package:flutter/material.dart';

class ActivityModel {
  final int id;
  final String action;
  final String subjectName;
  final String lessonTitle;
  final String createdAt;

  ActivityModel({
    required this.id,
    required this.action,
    required this.subjectName,
    required this.lessonTitle,
    required this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      action: json['action'],
      subjectName: json['subject_name'] ?? '',
      lessonTitle: json['lesson_title'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'subject_name': subjectName,
      'lesson_title': lessonTitle,
      'created_at': createdAt,
    };
  }
}
