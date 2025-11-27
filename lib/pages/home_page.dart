import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../providers/navigation_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lanjutkan perjalanan belajar Anda hari ini',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Akses Cepat',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildQuickActionCard(
                  context,
                  icon: Icons.book,
                  title: 'Pelajaran',
                  subtitle: 'Jelajahi materi',
                  onTap: () {
                    context.read<NavigationProvider>().setIndex(1);
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.history,
                  title: 'Aktivitas',
                  subtitle: 'Riwayat belajar',
                  onTap: () {
                    context.read<NavigationProvider>().setIndex(2);
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.bookmark,
                  title: 'Bookmark',
                  subtitle: 'Materi tersimpan',
                  onTap: () {
                    context.read<NavigationProvider>().setIndex(3);
                  },
                ),
                _buildQuickActionCard(
                  context,
                  icon: Icons.emoji_events,
                  title: 'Gamifikasi',
                  subtitle: 'Pencapaian & level',
                  onTap: () {
                    context.read<NavigationProvider>().setIndex(4);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Learning Stats
            Text(
              'Statistik Belajar',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      icon: Icons.school,
                      value: '0',
                      label: 'Pelajaran\nSelesai',
                    ),
                    _buildStatItem(
                      context,
                      icon: Icons.access_time,
                      value: '0h',
                      label: 'Waktu\nBelajar',
                    ),
                    _buildStatItem(
                      context,
                      icon: Icons.star,
                      value: '0',
                      label: 'Poin\nGamifikasi',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Notification Test
            Text(
              'Pengaturan',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Tes Notifikasi'),
                    subtitle: const Text('Kirim notifikasi tes'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      NotificationService.showInstantNotification(
                        'Tes Notifikasi',
                        'Ini adalah notifikasi tes dari Smart Classroom.',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Notifikasi tes telah dikirim'),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  FutureBuilder<bool>(
                    future: NotificationService.isReminderEnabled(),
                    builder: (context, snapshot) {
                      final enabled = snapshot.data ?? true;
                      return ListTile(
                        leading: Icon(
                          enabled
                              ? Icons.notifications_active
                              : Icons.notifications_off,
                        ),
                        title: const Text('Pengingat Belajar Harian'),
                        subtitle: Text(
                          enabled
                              ? 'Aktif - Setiap hari pukul 08:00'
                              : 'Nonaktif',
                        ),
                        trailing: Switch(
                          value: enabled,
                          onChanged: (value) async {
                            await NotificationService.toggleReminder(value);
                            // Force rebuild
                            if (context.mounted) {
                              (context as Element).markNeedsBuild();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
