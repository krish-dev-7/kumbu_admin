class Attendance {
  final String id;
  final DateTime entry;
  final DateTime? exit;
  final String memberId;
  final int gymMemberId;
  final String memberName;
  final String memberNumber;
  final String membershipDuration;
  final DateTime membershipEndDate;

  Attendance({
    required this.id,
    required this.entry,
    this.exit,
    required this.memberId,
    required this.gymMemberId,
    required this.memberName,
    required this.memberNumber, required this.membershipDuration, required this.membershipEndDate,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['_id'],
      entry: DateTime.parse(json['entry']),
      exit: json['exit'] != null ? DateTime.parse(json['exit']) : null,
      memberId: json['member']['_id'],
      gymMemberId: json['member']['gymMemberID'],
      memberName: json['member']['name'],
      memberNumber: json['member']['phoneNumber'],
      membershipDuration: json['member']['membershipDuration'],
      membershipEndDate: DateTime.parse(json['member']['membershipEndDate']),
    );
  }
}
