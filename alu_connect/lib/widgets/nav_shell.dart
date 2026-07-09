import 'package:flutter/material.dart';
import '../screens/student/home_screen.dart';
import '../screens/student/applications_screen.dart';
import '../screens/student/profile_screen.dart';
import '../theme/app_theme.dart';

/// Wraps the student's Home / Applications / Profile screens in one
/// bottom-navigation shell, same pattern as the sample UI's tab bar.
class StudentNavShell extends StatefulWidget {
  const StudentNavShell({super.key});

  @override
  State<StudentNavShell> createState() => _StudentNavShellState();
}

class _StudentNavShellState extends State<StudentNavShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    ApplicationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
