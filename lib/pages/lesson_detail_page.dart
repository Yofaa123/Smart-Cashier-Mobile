import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../providers/lesson_provider.dart';

class LessonDetailPage extends StatefulWidget {
  final Map lesson;

  const LessonDetailPage({super.key, required this.lesson});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().fetchDifficulty(widget.lesson['id']);
    });
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
            const SizedBox(height: 24),
            Consumer<LessonProvider>(
              builder: (context, lessonProvider, _) {
                if (lessonProvider.isLoadingDifficulty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 16),
                          Text('Memuat prediksi...'),
                        ],
                      ),
                    ),
                  );
                } else if (lessonProvider.error != null) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Gagal memuat prediksi'),
                    ),
                  );
                } else if (lessonProvider.difficulty != null &&
                    lessonProvider.score != null) {
                  final percentage = (lessonProvider.score! * 100).round();
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prediksi Kesulitan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('${lessonProvider.difficulty} (${percentage}%)'),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 32),
            Consumer<ProgressProvider>(
              builder: (context, progressProvider, _) {
                return progressProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final success = await progressProvider.markComplete(
                            widget.lesson['id'],
                          );
                          if (!context.mounted) return;
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Progress tersimpan'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gagal menyimpan progress'),
                              ),
                            );
                          }
                        },
                        child: const Text('Tandai Selesai'),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
