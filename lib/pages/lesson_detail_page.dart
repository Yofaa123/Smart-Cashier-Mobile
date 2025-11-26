import 'package:flutter/material.dart';

class LessonDetailPage extends StatelessWidget {
  final Map lesson;

  const LessonDetailPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson Detail')),
      body: Center(child: Text('Detail for lesson ${lesson['title']}')),
    );
  }
}
