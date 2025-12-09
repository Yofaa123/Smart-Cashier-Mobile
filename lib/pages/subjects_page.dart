import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../providers/bookmark_provider.dart';
import '../config/api.dart';
import '../models/subject.dart';
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

  String getSubjectImage(String name) {
    switch (name.toLowerCase()) {
      case "matematika":
        return "assets/images/subjects/matematika.jpeg";
      case "bahasa inggris":
        return "assets/images/subjects/bahasa_inggris.jpg";
      case "ipa":
        return "assets/images/subjects/ipa.jpeg";
      case "teknologi":
        return "assets/images/subjects/teknologi.png";
      default:
        return "assets/images/subjects/default.jpg";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkProvider>().fetchSubjectBookmarks();
    });
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mata Pelajaran',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Cari mata pelajaran...",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onChanged: filterSubjects,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredSubjects.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada mata pelajaran',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        final subject = filteredSubjects[index];
                        final bookmarkProvider = context
                            .watch<BookmarkProvider>();
                        final isBookmarked = bookmarkProvider
                            .isSubjectBookmarked(subject['id']);
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                  image: AssetImage(
                                    getSubjectImage(subject['name']),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              subject['name'],
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              subject['description'],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  onPressed: () async {
                                    await bookmarkProvider
                                        .toggleSubjectBookmark(
                                          SubjectModel.fromJson(subject),
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isBookmarked
                                              ? 'Dihapus dari bookmark'
                                              : 'Ditambahkan ke bookmark',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LessonsPage(subjectId: subject['id']),
                                ),
                              );
                            },
                          ),
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
