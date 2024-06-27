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
}
