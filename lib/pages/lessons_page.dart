import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../config/api.dart';
import 'lesson_detail_page.dart';

class LessonsPage extends StatefulWidget {
  final int subjectId;

  const LessonsPage({super.key, required this.subjectId});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  List lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLessons();
  }

  Future<void> fetchLessons() async {
    setState(() {
      isLoading = true;
    });
    final token = context.read<AuthProvider>().token;
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/subjects/${widget.subjectId}/lessons'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        lessons = data['lessons'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        lessons = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : lessons.isEmpty
            ? const Center(child: Text('Belum ada lesson'))
            : ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return ListTile(
                    title: Text(lesson['title']),
                    subtitle: Text(lesson['level']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonDetailPage(lesson: lesson),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
