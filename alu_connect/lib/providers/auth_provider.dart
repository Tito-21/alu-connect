import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

/// Holds the currently signed-in user. Any widget wrapped in a Consumer
/// or using context.watch<AuthProvider>() rebuilds automatically the
/// moment sign-in/sign-out happens -- that's the "state propagation"
/// you need to demo live.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _currentUser != null;

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    try {
      _currentUser = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      _currentUser = await _authService.signIn(email: email, password: password);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _friendlyError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('email-already-in-use')) return 'That email is already registered.';
    if (msg.contains('wrong-password') || msg.contains('user-not-found')) {
      return 'Incorrect email or password.';
    }
    if (msg.contains('weak-password')) return 'Password should be at least 6 characters.';
    return 'Something went wrong. Please try again.';
  }
}
