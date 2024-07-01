import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/Member.dart';

class MemberService {
  static const String baseUrl = 'http://127.0.0.1:3000'; // Replace with your API base URL

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
        print(jsonData);
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
}
