import 'dart:async';
import 'package:flutter/material.dart';
import '../models/opportunity.dart';
import '../services/firestore_service.dart';

/// Owns the live list of opportunities. It subscribes once to a Firestore
/// stream and re-broadcasts changes to every screen listening to it, so a
/// startup posting a new opportunity shows up on a student's Home screen
/// instantly -- no manual refresh needed.
class OpportunityProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<Opportunity> _opportunities = [];
  StreamSubscription? _sub;
  bool _isLoading = true;

  List<Opportunity> get opportunities => _opportunities;
  bool get isLoading => _isLoading;

  OpportunityProvider() {
    _listenToOpportunities();
  }

  void _listenToOpportunities() {
    _sub = _service.watchOpenOpportunities().listen((data) {
      _opportunities = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  List<Opportunity> search(String query, {String? category}) {
    return _opportunities.where((o) {
      final matchesQuery = query.isEmpty ||
          o.title.toLowerCase().contains(query.toLowerCase()) ||
          o.skillsRequired.any((s) => s.toLowerCase().contains(query.toLowerCase()));
      final matchesCategory = category == null || category == 'All' || o.category == category;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<void> postOpportunity(Opportunity opp) {
    return _service.createOpportunity(opp);
  }

  Future<void> closeOpportunity(String id) {
    return _service.updateOpportunity(id, {'isOpen': false});
  }

  Future<void> deleteOpportunity(String id) {
    return _service.deleteOpportunity(id);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
