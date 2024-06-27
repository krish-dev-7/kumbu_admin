enum MembershipLevel {
  BRONZE,
  SILVER,
  GOLD,
  DIAMOND,
  PLATINUM,
}

class GymMember {
  // Properties
  final String id;
  final String name;
  final int age;
  final String gender;
  final String currentPackageID; // Not sure what this field represents, may need clarification
  final String membershipDuration;
  final DateTime membershipStartDate;
  final DateTime membershipEndDate;
  final MembershipLevel level;
  final String email;
  final String phoneNumber;
  final String address;
  final String? imageUrl;
  bool isActive;
  final List<String> purchaseOrderHistories;
  final List<String> dietID;
  final int daysAttended;

  // Constructor
  GymMember({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.currentPackageID,
    required this.membershipDuration,
    required this.membershipStartDate,
    required this.membershipEndDate,
    required this.level,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.imageUrl,
    this.isActive = true,
    this.purchaseOrderHistories = const [],
    required this.dietID,
    required this.daysAttended,
  });

  // Method to calculate the remaining days of membership
  int getRemainingDays() {
    final today = DateTime.now();
    int days = membershipEndDate.difference(today).inDays;
    if (days < 0) {
      isActive = false;
    }
    return days;
  }

  // Method to check if membership is active
  bool isMembershipActive() {
    final today = DateTime.now();
    return today.isBefore(membershipEndDate);
  }

  String get subscriptionDue {
    return '${getRemainingDays()} days remaining';
  }

  // Method to convert GymMember object to a Map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'currentPackageID': currentPackageID,
      'membershipDuration': membershipDuration,
      'membershipStartDate': membershipStartDate.toString(),
      'membershipEndDate': membershipEndDate.toString(),
      'level': level.toString().split('.').last, // Convert enum to string
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'purchaseOrderHistories': purchaseOrderHistories,
      'dietID': dietID,
      'daysAttended': daysAttended,
    };
  }

  // Method to create a GymMember object from a Map (useful for JSON deserialization)
  factory GymMember.fromMap(Map<String, dynamic> map) {
    return GymMember(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      currentPackageID: map['currentPackageID'],
      membershipDuration: map['membershipDuration'],
      membershipStartDate: DateTime.parse(map['membershipStartDate']),
      membershipEndDate: DateTime.parse(map['membershipEndDate']),
      level: MembershipLevel.values.firstWhere((e) => e.toString().split('.').last == map['level']),
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      imageUrl: map['imageUrl'],
      isActive: map['isActive'],
      purchaseOrderHistories: List<String>.from(map['purchaseOrderHistories']),
      dietID: map['dietID'],
      daysAttended: map['daysAttended'],
    );
  }
}
