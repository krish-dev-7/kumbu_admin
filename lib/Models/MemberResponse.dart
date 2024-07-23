import 'Member.dart';

class MemberResponse {
  List<GymMember> members;
  int currentPage;
  int totalPages;

  MemberResponse({required this.members, required this.currentPage, required this.totalPages});

  factory MemberResponse.fromJson(Map<String, dynamic> json) {
    return MemberResponse(
      members: List<GymMember>.from(json['members'].map((x) => GymMember.fromMap(x))),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}