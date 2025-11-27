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
  List filteredLessons = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLessons();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        filteredLessons = lessons;
        isLoading = false;
      });
    } else {
      setState(() {
        lessons = [];
        filteredLessons = [];
        isLoading = false;
      });
    }
  }

  void filterLessons(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLessons = lessons;
      } else {
        filteredLessons = lessons.where((lesson) {
          final title = lesson['title'].toString().toLowerCase();
          final level = lesson['level'].toString().toLowerCase();
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery) || level.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Cari...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterLessons,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredLessons.isEmpty
                  ? const Center(child: Text('Belum ada lesson'))
                  : ListView.builder(
                      itemCount: filteredLessons.length,
                      itemBuilder: (context, index) {
                        final lesson = filteredLessons[index];
                        return ListTile(
                          title: Text(lesson['title']),
                          subtitle: Text(lesson['level']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LessonDetailPage(lesson: lesson),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
