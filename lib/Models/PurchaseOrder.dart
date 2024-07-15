class PurchaseOrder {
  final String purchaseOrderId;
  final DateTime timeOfPO;
  final double amountPaid;
  final String packageId;
  final DateTime membershipStartDate;
  final DateTime membershipEndDate;
  final String memberId;
  final int gymMemberID;

  PurchaseOrder({
    required this.purchaseOrderId,
    required this.timeOfPO,
    required this.amountPaid,
    required this.packageId,
    required this.membershipStartDate,
    required this.membershipEndDate,
    required this.memberId,
    required this.gymMemberID
  });

  factory PurchaseOrder.fromMap(Map<String, dynamic> map) {
    return PurchaseOrder(
      purchaseOrderId: map['_id'],
      timeOfPO: DateTime.parse(map['timeOfPO']),
      amountPaid: map['amountPaid'].toDouble(),
      packageId: map["_id"],
      membershipStartDate: DateTime.parse(map['membershipStartDate']),
      membershipEndDate: DateTime.parse(map['membershipEndDate']),
      gymMemberID: map['gymMemberID'], memberId: map['memberID'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'purchaseOrderId': purchaseOrderId,
      'timeOfPO': timeOfPO.toString(),
      'amountPaid': amountPaid,
      'packageID': packageId,
      'membershipStartDate': membershipStartDate.toString(),
      'membershipEndDate': membershipEndDate.toString(),
      'gymMemberID': gymMemberID,
      'memberID':memberId

    };
  }
}
