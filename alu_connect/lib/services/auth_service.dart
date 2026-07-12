import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

/// Wraps FirebaseAuth so the rest of the app never talks to Firebase
/// directly. If we ever swap auth providers, only this file changes.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final cred = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 15));

    final user = AppUser(
      uid: cred.user!.uid,
      name: name,
      email: email,
      role: role,
    );

    // Create the matching user profile document in Firestore.
    await _db
        .collection('users')
        .doc(user.uid)
        .set(user.toMap())
        .timeout(const Duration(seconds: 15));
    return user;
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 15));
    final doc = await _db
        .collection('users')
        .doc(cred.user!.uid)
        .get()
        .timeout(const Duration(seconds: 15));
    return AppUser.fromMap(cred.user!.uid, doc.data() ?? {});
  }

  Future<void> signOut() => _auth.signOut();
}