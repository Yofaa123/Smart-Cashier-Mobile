import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import 'lesson_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmark Saya')),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, _) {
          if (favoriteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = favoriteProvider.favorites;

          if (favorites.isEmpty) {
            return const Center(child: Text('Belum ada bookmark'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final lesson = favorites[index];
              return ListTile(
                title: Text(lesson['title'] ?? ''),
                subtitle: Text(lesson['level'] ?? ''),
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
          );
        },
      ),
    );
  }
}
