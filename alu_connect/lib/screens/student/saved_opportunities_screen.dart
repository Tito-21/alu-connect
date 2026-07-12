import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/opportunity_card.dart';
import 'opportunity_detail_screen.dart';

/// Shows only the opportunities the student has bookmarked. Filters the
/// same live OpportunityProvider list against the user's saved IDs, so
/// this list updates in real time too -- no separate Firestore query needed.
class SavedOpportunitiesScreen extends StatelessWidget {
  const SavedOpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final allOpportunities = context.watch<OpportunityProvider>().opportunities;
    final savedIds = auth.currentUser?.savedOpportunities ?? [];
    final saved = allOpportunities.where((o) => savedIds.contains(o.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Opportunities')),
      body: saved.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nothing saved yet. Tap the bookmark icon on any opportunity to save it here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textGrey),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: saved.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final opp = saved[i];
                return OpportunityCard(
                  opportunity: opp,
                  isBookmarked: true,
                  onBookmarkTap: () =>
                      context.read<AuthProvider>().toggleSavedOpportunity(opp.id),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => OpportunityDetailScreen(opportunity: opp)),
                  ),
                );
              },
            ),
    );
  }
}