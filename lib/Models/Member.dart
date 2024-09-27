import 'Diet.dart';
import 'Package.dart';
import 'PurchaseOrder.dart';

enum MembershipLevel {
  BRONZE,
  SILVER,
  GOLD,
  DIAMOND,
  PLATINUM,
}


class GymMember {
  final String id;
  final int gymMemberID;
   String name;
   bool isPT;
   int age;
   String gender;
   Package? currentPackage;
   String membershipDuration;
   DateTime membershipStartDate;
   DateTime membershipEndDate;
   MembershipLevel level;
   String email;
   String phoneNumber;
   String address;
   String? imageUrl;
  bool isActive;
   List<dynamic> purchaseOrderHistories;
   String dietTemplateID;
   int daysAttended;
  String notes;

  GymMember({
    required this.id,
    required this.gymMemberID,
    required this.name,
    required this.age,
    required this.gender,
    this.currentPackage,
    required this.membershipDuration,
    required this.membershipStartDate,
    required this.membershipEndDate,
    required this.level,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.imageUrl,
    this.isActive = true,
    this.isPT=false,
    this.purchaseOrderHistories = const [],
    this.dietTemplateID = "",
    required this.daysAttended, required this.notes,
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

  String getMembershipDuration() {
    return currentPackage?.getReadableDuration()??membershipDuration;
  }

  // Method to convert GymMember object to a Map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'gymMemberID': gymMemberID,
      'isPT':isPT,
      'name': name,
      'age': age,
      'gender': gender,
      'currentPackageID': currentPackage?.packageID,
      'membershipDuration': membershipDuration,
      'membershipStartDate': membershipStartDate.toString(),
      'membershipEndDate': membershipEndDate.toString(),
      'level': level.toString().split('.').last, // Convert enum to string
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'purchaseOrderHistories': purchaseOrderHistories.map((order) => order.toMap()).toList(),
      'dietTemplateID': "",
      'daysAttended': daysAttended,
      'notes':notes
    };
  }

  // Method to create a GymMember object from a Map (useful for JSON deserialization)
  factory GymMember.fromMap(Map<String, dynamic> map) {
    return GymMember(
      id: map['_id'],
      gymMemberID: map['gymMemberID'],
      isPT: map['isPT'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      currentPackage: map['currentPackageID']!=null?Package.fromJson(map['currentPackageID']):null,
      membershipDuration: map['membershipDuration'],
      membershipStartDate: DateTime.parse(map['membershipStartDate']),
      membershipEndDate: DateTime.parse(map['membershipEndDate']),
      level: MembershipLevel.values.firstWhere((e) => e.toString().split('.').last == map['level']),
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      imageUrl: map['imageUrl'],
      isActive: map['isActive'],
      purchaseOrderHistories: List<dynamic>.from(map['purchaseOrderHistories'].map((order) => PurchaseOrder.fromMap(order))),
      dietTemplateID: map['dietTemplateID'] ?? "",
      daysAttended: map['daysAttended'],
      notes: map['notes']
    );
  }
}




extension DietExt on Diet {
  Map<String, dynamic> toMap() {
    return {
      'dietID': dietID,
      'period': period,
      'quantity': quantity,
      'food': food,
    };
  }
}
