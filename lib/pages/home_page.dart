import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'subjects_page.dart';
import 'recommendation_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Classroom'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Mata Pelajaran'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubjectsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Rekomendasi Belajar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecommendationPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
