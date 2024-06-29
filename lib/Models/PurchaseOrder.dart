class PurchaseOrder {
  final String purchaseOrderId;
  final DateTime timeOfPO;
  final double amountPaid;
  final String packageId;
  final DateTime membershipStartDate;
  final DateTime membershipEndDate;
  final String memberId;

  PurchaseOrder({
    required this.purchaseOrderId,
    required this.timeOfPO,
    required this.amountPaid,
    required this.packageId,
    required this.membershipStartDate,
    required this.membershipEndDate,
    required this.memberId,
  });

  factory PurchaseOrder.fromMap(Map<String, dynamic> map) {
    return PurchaseOrder(
      purchaseOrderId: map['purchaseOrderID'],
      timeOfPO: DateTime.parse(map['timeOfPO']),
      amountPaid: map['amountPaid'].toDouble(),
      packageId: map['package'],
      membershipStartDate: DateTime.parse(map['membershipStartDate']),
      membershipEndDate: DateTime.parse(map['membershipEndDate']),
      memberId: map['memberID'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'purchaseOrderId': purchaseOrderId,
      'timeOfPO': timeOfPO.toIso8601String(),
      'amountPaid': amountPaid,
      'package': packageId,
      'membershipStartDate': membershipStartDate.toIso8601String(),
      'membershipEndDate': membershipEndDate.toIso8601String(),
      'memberID': memberId,
    };
  }
}
