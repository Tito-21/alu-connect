/// A person using the app. Role decides which side of the app they see:
/// - "student"  -> browses/applies to opportunities
/// - "startup"  -> posts opportunities and reviews applicants
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'student' or 'startup'
  final List<String> skills;
  final String location;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.skills = const [],
    this.location = '',
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      skills: List<String>.from(data['skills'] ?? []),
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'skills': skills,
      'location': location,
    };
  }
}
