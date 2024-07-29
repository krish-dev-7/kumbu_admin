import 'package:kumbu_admin/Models/Member.dart';

import '../Common/config.dart';
import 'Package.dart';

class MembershipRequest {
  final String? id;
  final String requesterID;
  final DateTime requestedDate;
  final String name;
  final int age;
  final String gender;
  final Package? currentPackageID;
  final String membershipDuration;
  final DateTime membershipStartDate;
  final DateTime membershipEndDate;
  final String level;
  final String email;
  final String phoneNumber;
  final String address;
  final List<String> purchaseOrderHistories;
  final bool isApproved;

  MembershipRequest({
    this.id,
    required this.requesterID,
    required this.requestedDate,
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
    this.purchaseOrderHistories = const[],
    required this.isApproved,
  });

  factory MembershipRequest.fromJson(Map<String, dynamic> json) {
    return MembershipRequest(
      id: json['_id'],
      requesterID: json['requesterID'],
      requestedDate: DateTime.parse(json['requestedDate']),
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      currentPackageID: json['currentPackageID'],
      membershipDuration: json['membershipDuration'],
      membershipStartDate: DateTime.parse(json['membershipStartDate']),
      membershipEndDate: DateTime.parse(json['membershipEndDate']),
      level: json['level'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      purchaseOrderHistories: List<String>.from(json['purchaseOrderHistories']),
      isApproved: json['isApproved'],
    );
  }

  factory MembershipRequest.fromGymMember(GymMember member, String requesterID){
    return MembershipRequest(
      name: member.name,
      age: member.age,
      gender: member.gender,
      email: member.email,
      phoneNumber: member.phoneNumber,
      address: member.address,
      membershipDuration: member.membershipDuration,
      membershipStartDate: member.membershipStartDate,
      membershipEndDate: member.membershipEndDate,
      currentPackageID: member.currentPackage, // Assign selected package
      level: member.level.name, // Example: Set membership level
      requesterID: requesterID, requestedDate: DateTime.now(), isApproved: false,
      );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requesterID': requesterID,
      'requestedDate': requestedDate.toIso8601String(),
      'name': name,
      'age': age,
      'gender': gender,
      'currentPackageID': currentPackageID,
      'membershipDuration': membershipDuration,
      'membershipStartDate': membershipStartDate.toIso8601String(),
      'membershipEndDate': membershipEndDate.toIso8601String(),
      'level': level,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'purchaseOrderHistories': purchaseOrderHistories,
      'isApproved': isApproved,
    };
  }
}
