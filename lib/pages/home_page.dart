import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../services/notification_service.dart';
import 'subjects_page.dart';
import 'recommendation_page.dart';
import 'profile_page.dart';
import 'recent_activity_page.dart';
import 'favorite_page.dart';
import 'gamification_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeContent(),
    SubjectsPage(),
    RecommendationPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Classroom'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          if (_selectedIndex == 0)
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Mata Pelajaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Rekomendasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Mata Pelajaran'),
          onTap: () {
            // Navigate or set index
          },
        ),
        ListTile(
          title: const Text('Rekomendasi Belajar'),
          onTap: () {
            // Navigate or set index
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecentActivityPage()),
            );
          },
          child: const Text("Recent Activity"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritePage()),
            );
          },
          child: const Text("Bookmark Saya"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GamificationPage()),
            );
          },
          child: const Text("Gamification"),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            NotificationService.showInstantNotification(
              'Tes Notifikasi',
              'Ini adalah notifikasi tes.',
            );
          },
          child: const Text("Tes Notifikasi"),
        ),
        const SizedBox(height: 16),
        FutureBuilder<bool>(
          future: NotificationService.isReminderEnabled(),
          builder: (context, snapshot) {
            final enabled = snapshot.data ?? true;
            return ElevatedButton(
              onPressed: () async {
                await NotificationService.toggleReminder(!enabled);
                setState(() {}); // Refresh
              },
              child: Text(
                enabled
                    ? "Matikan Pengingat Belajar"
                    : "Aktifkan Pengingat Belajar",
              ),
            );
          },
        ),
      ],
    );
  }
}
