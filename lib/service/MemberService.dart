import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumbu_admin/Common/Constants.dart';
import '../../Models/Member.dart';
import '../Models/MemberResponse.dart';

class MemberService {
  static String baseUrl = "${BASE_URL}"; // Replace with your API base URL
  // static const String baseUrl = 'http://localhost:3000'; // Replace with your API base URL

  Future<void> addMember(GymMember newMember) async {
    String apiUrl = '$baseUrl/api/members'; // Replace with your specific endpoint
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newMember.toMap()),
      );

      if (response.statusCode == 200) {
        // Member added successfully
        return;
      } else {
        throw Exception('Failed to add member');
      }
    } catch (e) {
      throw Exception('Error adding member: $e');
    }
  }

  Future<List<GymMember>> getAllMembers() async {
    String apiUrl = '$baseUrl/api/members'; // Replace with your specific endpoint
    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        print(response.body);
        return jsonData.map((member) => GymMember.fromMap(member)).toList();
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  Future<void> updateDietTemplateId(String memberId, String dietTemplateId) async {
    String apiUrl = '$baseUrl/api/members';
    final response = await http.patch(
      Uri.parse('$apiUrl/$memberId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'dietTemplateID': dietTemplateId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update diet template ID');
    }
  }

  Future<void> updateMember(GymMember member) async {
    final url = '$baseUrl/api/members/${member.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': member.name,
        'age': member.age,
        'gender': member.gender,
        'email': member.email,
        'phoneNumber': member.phoneNumber,
        'address': member.address,
        'dietTemplateID': member.dietTemplateID,
        'currentPackageID':member.currentPackage?.packageID,
        'membershipStartDate':member.membershipStartDate.toString(),
        'membershipEndDate':member.membershipEndDate.toString(),
        'level':member.level.name
        // Add other member fields as needed
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update member');
    }
  }
  Future<void> updateMembershipDetails(String memberId, String packageId,  DateTime endDate) async {
    print("updateMembershipDetail $memberId");
    final url = '$baseUrl/api/members/$memberId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'currentPackageID': packageId,
        'membershipEndDate': endDate.toIso8601String()
      }),
    );
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to update membership details');
    }
  }
  Future<MemberResponse> getMembers({int page = 1, int limit = 20, String search = ''}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/members?page=$page&limit=$limit&search=$search'),
    );

    if (response.statusCode == 200) {
      print(search +" searched -> "+ response.body);
      return MemberResponse.fromJson(json.decode(response.body));
    } else {
      print(search +" searched -> "+ response.body);
      throw Exception('Failed to load members');
    }
  }
}
