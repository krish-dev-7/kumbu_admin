class GymMember {
  // Properties
  final String id;
  final String name;
  final int age;
  final String gender;
  final String membershipType;
  final String membershipDuration;
  final DateTime membershipStartDate;
  final DateTime membershipEndDate;
  final String email;
  final String phoneNumber;
  final String address;

  // Constructor
  GymMember({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.membershipType,
    required this.membershipDuration,
    required this.membershipStartDate,
    required this.membershipEndDate,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  // Method to calculate the remaining days of membership
  int getRemainingDays() {
    final today = DateTime.now();
    return membershipEndDate.difference(today).inDays;
  }

  // Method to check if membership is active
  bool isMembershipActive() {
    final today = DateTime.now();
    return today.isBefore(membershipEndDate);
  }

  // Method to convert GymMember object to a Map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'membershipType': membershipType,
      'membershipStartDate': membershipStartDate.toIso8601String(),
      'membershipEndDate': membershipEndDate.toIso8601String(),
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // Method to create a GymMember object from a Map (useful for JSON deserialization)
  factory GymMember.fromMap(Map<String, dynamic> map) {
    return GymMember(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      membershipType: map['membershipType'],
      membershipDuration: map['membershipDuration'],
      membershipStartDate: DateTime.parse(map['membershipStartDate']),
      membershipEndDate: DateTime.parse(map['membershipEndDate']),
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
    );
  }
}
