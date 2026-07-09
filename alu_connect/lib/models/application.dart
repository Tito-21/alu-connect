import 'package:cloud_firestore/cloud_firestore.dart';

/// A student's application to one opportunity.
/// status moves: applied -> interview -> accepted (or rejected)
class Application {
  final String id;
  final String opportunityId;
  final String opportunityTitle;
  final String studentId;
  final String studentName;
  final String status;
  final DateTime appliedAt;

  Application({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.studentId,
    required this.studentName,
    required this.status,
    required this.appliedAt,
  });

  factory Application.fromMap(String id, Map<String, dynamic> data) {
    return Application(
      id: id,
      opportunityId: data['opportunityId'] ?? '',
      opportunityTitle: data['opportunityTitle'] ?? '',
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      status: data['status'] ?? 'applied',
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'studentId': studentId,
      'studentName': studentName,
      'status': status,
      'appliedAt': Timestamp.fromDate(appliedAt),
    };
  }
}
