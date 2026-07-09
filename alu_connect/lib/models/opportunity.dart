import 'package:cloud_firestore/cloud_firestore.dart';

/// A single internship/opportunity posting created by a startup.
class Opportunity {
  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final List<String> skillsRequired;
  final String workType; // e.g. Part-time, On-campus, Remote
  final String category; // Design, Engineering, Marketing, Data, Other
  final DateTime postedAt;
  final bool isOpen;

  Opportunity({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.skillsRequired,
    required this.workType,
    required this.category,
    required this.postedAt,
    this.isOpen = true,
  });

  factory Opportunity.fromMap(String id, Map<String, dynamic> data) {
    return Opportunity(
      id: id,
      startupId: data['startupId'] ?? '',
      startupName: data['startupName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      skillsRequired: List<String>.from(data['skillsRequired'] ?? []),
      workType: data['workType'] ?? '',
      category: data['category'] ?? 'Other',
      postedAt: (data['postedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOpen: data['isOpen'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'description': description,
      'skillsRequired': skillsRequired,
      'workType': workType,
      'category': category,
      'postedAt': Timestamp.fromDate(postedAt),
      'isOpen': isOpen,
    };
  }
}
