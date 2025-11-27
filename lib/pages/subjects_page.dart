import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../config/api.dart';
import 'lessons_page.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List subjects = [];
  List filteredSubjects = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchSubjects() async {
    setState(() {
      isLoading = true;
    });
    final token = context.read<AuthProvider>().token;
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/subjects'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        subjects = data['subjects'] ?? [];
        filteredSubjects = subjects;
        isLoading = false;
      });
    } else {
      setState(() {
        subjects = [];
        filteredSubjects = [];
        isLoading = false;
      });
    }
  }

  void filterSubjects(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSubjects = subjects;
      } else {
        filteredSubjects = subjects.where((subject) {
          final name = subject['name'].toString().toLowerCase();
          final description = subject['description'].toString().toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) ||
              description.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mata Pelajaran')),
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
              onChanged: filterSubjects,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSubjects.isEmpty
                  ? const Center(child: Text('Belum ada data'))
                  : ListView.builder(
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        final subject = filteredSubjects[index];
                        return ListTile(
                          title: Text(subject['name']),
                          subtitle: Text(subject['description']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LessonsPage(subjectId: subject['id']),
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
