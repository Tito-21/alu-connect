/// A student-led venture. Only "verified" startups are allowed to have
/// their opportunities visible to students -- this is how we stop random
/// unverified accounts from posting fake internships.
class Startup {
  final String id;
  final String ownerUid;
  final String name;
  final String description;
  final bool isVerified;

  Startup({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.description,
    this.isVerified = false,
  });

  factory Startup.fromMap(String id, Map<String, dynamic> data) {
    return Startup(
      id: id,
      ownerUid: data['ownerUid'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      isVerified: data['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerUid': ownerUid,
      'name': name,
      'description': description,
      'isVerified': isVerified,
    };
  }
}
