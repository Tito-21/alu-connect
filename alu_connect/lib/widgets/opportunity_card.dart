import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../theme/app_theme.dart';

/// The white rounded card used in "Recent opportunities" and search
/// results -- mirrors the sample UI's Social Media Assistant / Flutter
/// Developer cards.
class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bolt, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(opportunity.title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(opportunity.startupName,
                        style: const TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text('${opportunity.workType} • ${opportunity.category}',
                        style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                onPressed: onBookmarkTap,
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
