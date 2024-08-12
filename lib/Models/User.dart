class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> assignedMembers;
  final List<String> membershipRequests;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.assignedMembers,
    required this.membershipRequests,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      assignedMembers: List<String>.from(json['assignedMembers']),
      membershipRequests: List<String>.from(json['membershipRequests']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'assignedMembers': assignedMembers,
      'membershipRequests': membershipRequests,
    };
  }
}

