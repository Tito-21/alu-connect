import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  String _filter = 'All';
  final _tabs = const ['Applied', 'Interview', 'Accepted', 'All'];
  bool _startedListening = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final appProvider = context.watch<ApplicationProvider>();

    // Start listening for this student's applications once we know who they are.
    if (!_startedListening && auth.currentUser != null) {
      _startedListening = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ApplicationProvider>().listenForStudent(auth.currentUser!.uid);
      });
    }

    final items = appProvider.byStatus(_filter.toLowerCase());

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Applications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            Row(
              children: _tabs.map((t) {
                final selected = t == _filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(t),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = t),
                    selectedColor: AppTheme.primary,
                    labelStyle: TextStyle(color: selected ? Colors.white : AppTheme.textDark),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: appProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                      ? const Center(child: Text('No applications in this category yet.'))
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final a = items[i];
                            return Card(
                              child: ListTile(
                                title: Text(a.opportunityTitle),
                                subtitle: Text(
                                    'Applied ${DateFormat.yMMMd().format(a.appliedAt)}'),
                                trailing: _StatusBadge(status: a.status),
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

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'accepted':
        color = AppTheme.success;
        break;
      case 'interview':
        color = AppTheme.warning;
        break;
      default:
        color = AppTheme.textGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
