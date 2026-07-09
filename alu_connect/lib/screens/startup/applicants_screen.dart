import 'package:flutter/material.dart';
import '../../models/opportunity.dart';
import '../../models/application.dart';
import '../../services/firestore_service.dart';
import '../../theme/app_theme.dart';

/// Lets a startup see everyone who applied to one opportunity and move
/// their status forward -- this is the other half of the "application
/// tracking system" bonus feature (students see their own status, startups
/// update it here). Real-time via StreamBuilder, so both sides sync live.
class ApplicantsScreen extends StatelessWidget {
  final Opportunity opportunity;
  const ApplicantsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text('${opportunity.title} — Applicants')),
      body: StreamBuilder<List<Application>>(
        stream: service.watchApplicationsForOpportunity(opportunity.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final applicants = snapshot.data!;
          if (applicants.isEmpty) {
            return const Center(child: Text('No applicants yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: applicants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final a = applicants[i];
              return Card(
                child: ListTile(
                  title: Text(a.studentName),
                  subtitle: Text('Status: ${a.status}'),
                  trailing: DropdownButton<String>(
                    value: a.status,
                    underline: const SizedBox(),
                    items: const ['applied', 'interview', 'accepted', 'rejected']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        service.updateApplicationStatus(a.id, newStatus);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
