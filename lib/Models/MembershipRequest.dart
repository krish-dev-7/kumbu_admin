import 'package:kumbu_admin/Models/Member.dart';

import '../Common/config.dart';
import 'Package.dart';

class MembershipRequest {
  final String? id;
  final String requesterID;
  final bool isPT;
  final String requesterName;
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
    required this.requesterName,
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
    required this.isPT,
    this.purchaseOrderHistories = const[],
    required this.isApproved,
  });

  factory MembershipRequest.fromJson(Map<String, dynamic> json) {
    return MembershipRequest(
      id: json['_id'],
      requesterID: json['requesterID'],
      requestedDate: DateTime.parse(json['requestedDate']).toLocal(),
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      currentPackageID: json['currentPackageID']!=null?Package.fromJson(json['currentPackageID']):null,
      membershipDuration: json['membershipDuration'],
      membershipStartDate: DateTime.parse(json['membershipStartDate']),
      membershipEndDate: DateTime.parse(json['membershipEndDate']),
      level: json['level'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      purchaseOrderHistories: List<String>.from(json['purchaseOrderHistories']),
      isApproved: json['isApproved'], requesterName: json['requesterName'], isPT: json['isPT'],
    );
  }

  factory MembershipRequest.fromGymMember(GymMember member, String requesterID, String requesterName){
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
      requesterName: requesterName, isPT: member.isPT
      );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requesterID': requesterID,
      'requesterName': requesterName,
      'requestedDate': requestedDate.toString(),
      'name': name,
      'age': age,
      'gender': gender,
      'currentPackageID': currentPackageID?.packageID,
      'membershipDuration': membershipDuration,
      'membershipStartDate': membershipStartDate.toString(),
      'membershipEndDate': membershipEndDate.toString(),
      'level': level,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'purchaseOrderHistories': purchaseOrderHistories,
      'isApproved': isApproved,
      'isPT': isPT
    };
  }
}
