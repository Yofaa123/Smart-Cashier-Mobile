import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'subjects_page.dart';
import 'activity_page.dart';
import 'favorite_page.dart';
import 'gamification_page.dart';
import 'profile_page.dart';
import 'login_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = [
    const HomePage(),
    const SubjectsPage(),
    const ActivityPage(),
    const FavoritePage(),
    const GamificationPage(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
    const BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Pelajaran'),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'Aktivitas',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: 'Bookmark',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.emoji_events),
      label: 'Gamifikasi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Smart Classroom'),
            elevation: 0,
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
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      authProvider.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: navigationProvider.selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _navItems,
            currentIndex: navigationProvider.selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 8,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              navigationProvider.setIndex(index);
            },
          ),
        );
      },
    );
  }
}
