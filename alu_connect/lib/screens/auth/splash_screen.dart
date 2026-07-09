import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/nav_shell.dart';
import '../startup/startup_dashboard_screen.dart';
import 'sign_in_screen.dart';

/// First screen shown. Decides where to send the user based on whether
/// they're already signed in, and if so, which role they have.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isSignedIn) {
      return auth.currentUser!.role == 'startup'
          ? const StartupDashboardScreen()
          : const StudentNavShell();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.handshake_outlined, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              const Text('ALU Connect',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Students meet student startups',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primary,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
