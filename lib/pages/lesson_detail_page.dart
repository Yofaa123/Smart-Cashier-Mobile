import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../config/api.dart';

class LessonDetailPage extends StatefulWidget {
  final Map lesson;

  const LessonDetailPage({super.key, required this.lesson});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  Future<void> markComplete() async {
    final token = context.read<AuthProvider>().token;
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/progress/complete'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'lesson_id': widget.lesson['id']}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson berhasil diselesaikan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyelesaikan lesson')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Lesson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson['title'],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.lesson['level'],
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(widget.lesson['content']),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: markComplete,
        icon: const Icon(Icons.check),
        label: const Text('Tandai Selesai'),
      ),
    );
  }
}
