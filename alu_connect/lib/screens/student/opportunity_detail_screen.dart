import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/opportunity.dart';
import '../../providers/application_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final Opportunity opportunity;
  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final appProvider = context.watch<ApplicationProvider>();
    final alreadyApplied = appProvider.hasApplied(opportunity.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Opportunity Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.bolt, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(opportunity.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(opportunity.startupName,
                        style: const TextStyle(color: AppTheme.textGrey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: opportunity.skillsRequired
                  .map((s) => Chip(label: Text(s)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            _infoRow(Icons.schedule, opportunity.workType),
            _infoRow(Icons.category_outlined, opportunity.category),
            const SizedBox(height: 20),
            const Text('About', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 6),
            Text(opportunity.description, style: const TextStyle(color: AppTheme.textDark)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: alreadyApplied
                    ? null
                    : () async {
                        await context.read<ApplicationProvider>().apply(
                              opportunityId: opportunity.id,
                              opportunityTitle: opportunity.title,
                              studentId: auth.currentUser!.uid,
                              studentName: auth.currentUser!.name,
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Application submitted!')),
                          );
                          Navigator.pop(context);
                        }
                      },
                child: Text(alreadyApplied ? 'Already Applied' : 'Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textGrey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: AppTheme.textGrey)),
        ],
      ),
    );
  }
}
