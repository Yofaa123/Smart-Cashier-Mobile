class LessonModel {
  final int id;
  final int subjectId;
  final String title;
  final String content;
  final String level;
  final String duration;
  final String subjectName;
  int? bookmarkId; // For bookmark management

  LessonModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.content,
    required this.level,
    required this.duration,
    required this.subjectName,
    this.bookmarkId,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      subjectId: json['subject_id'] ?? 0,
      title: json['title'],
      content: json['content'] ?? '',
      level: json['level'],
      duration: '15 menit', // Hardcoded since not in JSON
      subjectName: json['subject']?['name'] ?? '',
      bookmarkId: json['bookmark_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'title': title,
      'content': content,
      'level': level,
      'duration': duration,
      'subject_name': subjectName,
      'bookmark_id': bookmarkId,
    };
  }
}
