import '../Models/Member.dart';

List<GymMember> sortMembersAlphabetically(List<GymMember> members) {
  members.sort((a, b) => a.name.compareTo(b.name));
  return members;
}