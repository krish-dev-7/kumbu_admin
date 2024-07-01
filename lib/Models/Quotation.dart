import 'package:flutter/foundation.dart';

import 'Package.dart';

class Quotation {
  final String quotationID; //_id
  final String requesterName;
  final int requesterID;
  final String requesterNumber;
  final Package package; // Nested object
  late final bool isApproved;
  final bool isPaid;

  Quotation({
    required this.quotationID,
    required this.requesterName,
    required this.requesterID,
    required this.requesterNumber,
    required this.package,
    required this.isApproved,
    required this.isPaid,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      quotationID: json['_id'],
      requesterName: json['requester']['name'],
      requesterID: json['requester']['gymMemberID'],
      requesterNumber: json['requester']['phoneNumber'],
      package: Package.fromJson(json['package']), // Parse package from JSON
      isApproved: json['isApproved'],
      isPaid: json['isPaid'],
    );
  }
}
