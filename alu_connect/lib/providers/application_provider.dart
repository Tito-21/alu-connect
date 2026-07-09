import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/application.dart';
import '../services/firestore_service.dart';

/// Tracks the applications belonging to whichever student is signed in.
/// Call [listenForStudent] once after login (see main.dart / home screen).
class ApplicationProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<Application> _applications = [];
  StreamSubscription? _sub;
  bool _isLoading = true;

  List<Application> get applications => _applications;
  bool get isLoading => _isLoading;

  List<Application> byStatus(String status) {
    if (status == 'All') return _applications;
    return _applications.where((a) => a.status == status).toList();
  }

  void listenForStudent(String studentId) {
    _sub?.cancel();
    _isLoading = true;
    _sub = _service.watchApplicationsByStudent(studentId).listen((data) {
      _applications = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> apply({
    required String opportunityId,
    required String opportunityTitle,
    required String studentId,
    required String studentName,
  }) {
    final app = Application(
      id: const Uuid().v4(),
      opportunityId: opportunityId,
      opportunityTitle: opportunityTitle,
      studentId: studentId,
      studentName: studentName,
      status: 'applied',
      appliedAt: DateTime.now(),
    );
    return _service.submitApplication(app);
  }

  bool hasApplied(String opportunityId) {
    return _applications.any((a) => a.opportunityId == opportunityId);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
