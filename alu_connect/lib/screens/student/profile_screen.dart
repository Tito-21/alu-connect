import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final apps = context.watch<ApplicationProvider>().applications;
    final user = auth.currentUser;

    final shortlisted = apps.where((a) => a.status == 'interview').length;
    final accepted = apps.where((a) => a.status == 'accepted').length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                  child: Text(
                    (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 28, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 10),
                Text(user?.name ?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text(user?.location.isNotEmpty == true ? user!.location : user?.email ?? '',
                    style: const TextStyle(color: AppTheme.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(label: 'Applications', value: apps.length),
              _StatItem(label: 'Shortlisted', value: shortlisted),
              _StatItem(label: 'Accepted', value: accepted),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.badge_outlined), title: const Text('My Profile')),
                ListTile(leading: const Icon(Icons.star_border), title: const Text('Skills & Interests')),
                ListTile(leading: const Icon(Icons.bookmark_border), title: const Text('Saved Opportunities')),
                ListTile(leading: const Icon(Icons.notifications_none), title: const Text('Notifications')),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () => context.read<AuthProvider>().signOut(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
      ],
    );
  }
}
