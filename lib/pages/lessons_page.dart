import 'package:flutter/material.dart';

class LessonsPage extends StatelessWidget {
  final int subjectId;

  const LessonsPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: Center(child: Text('Lessons for subject $subjectId')),
    );
  }
}
