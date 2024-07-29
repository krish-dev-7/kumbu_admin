class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final List<String> assignedMembers;
  final List<String> membershipRequests;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.assignedMembers,
    required this.membershipRequests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'assignedMembers': assignedMembers,
      'membershipRequests': membershipRequests,
    };
  }
}

