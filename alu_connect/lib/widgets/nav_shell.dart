import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/application_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/student/home_screen.dart';
import '../screens/student/applications_screen.dart';
import '../screens/student/profile_screen.dart';
import '../theme/app_theme.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser?.uid;
      if (uid != null) {
        context.read<ApplicationProvider>().listenForStudent(uid);
      }
    });
  }

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