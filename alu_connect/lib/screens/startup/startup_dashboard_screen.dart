import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/startup.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../services/firestore_service.dart';
import '../../theme/app_theme.dart';
import 'applicants_screen.dart';
import 'post_opportunity_screen.dart';
import '../../providers/application_provider.dart';
/// Home base for a startup account: shows verification status and the
/// list of opportunities they've posted, each tappable to see applicants.
class StartupDashboardScreen extends StatelessWidget {
  const StartupDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final ownerUid = auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<ApplicationProvider>().clear();
              context.read<AuthProvider>().signOut();
               },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('Post Opportunity'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PostOpportunityScreen()),
        ),
      ),
      body: StreamBuilder<Startup?>(
        stream: FirestoreService().watchStartupByOwner(ownerUid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // No startup profile yet -- create one automatically the
            // first time so opportunities can be linked to it.
            return _NoStartupYet(ownerUid: ownerUid, ownerName: auth.currentUser!.name);
          }

          final startup = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        startup.isVerified ? Icons.verified : Icons.hourglass_empty,
                        color: startup.isVerified ? AppTheme.success : AppTheme.warning,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          startup.isVerified
                              ? '${startup.name} is verified — your posts are live.'
                              : '${startup.name} is pending ALU verification. Opportunities stay hidden from students until approved.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Your Opportunities', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 10),
              Consumer<OpportunityProvider>(
                builder: (context, provider, _) {
                  final mine = provider.opportunities
                      .where((o) => o.startupId == startup.id)
                      .toList();
                  if (mine.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('No opportunities posted yet.'),
                    );
                  }
                  return Column(
                    children: mine.map((o) => Card(
                          child: ListTile(
                            title: Text(o.title),
                            subtitle: Text('${o.workType} • ${o.category}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ApplicantsScreen(opportunity: o)),
                            ),
                          ),
                        )).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoStartupYet extends StatelessWidget {
  final String ownerUid;
  final String ownerName;
  const _NoStartupYet({required this.ownerUid, required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront_outlined, size: 48, color: AppTheme.textGrey),
            const SizedBox(height: 12),
            const Text('Set up your startup profile to start posting.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final startup = Startup(
                  id: ownerUid, // one startup per owner keeps this simple
                  ownerUid: ownerUid,
                  name: ownerName,
                  description: '',
                  isVerified: false,
                );
                await FirestoreService().createStartup(startup);
              },
              child: const Text('Create Startup Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
