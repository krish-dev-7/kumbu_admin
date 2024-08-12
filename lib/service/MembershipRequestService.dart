import 'dart:convert';

import '../Models/MembershipRequest.dart';
import 'package:http/http.dart' as http;
import 'package:kumbu_admin/Common/Constants.dart';

class MembershipRequestService{
  final baseUrl= "${BASE_URL}/api";
  Future<List<MembershipRequest>> getAllMembershipRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/membershipRequests'));
    print("membershipRequestService@11 ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => MembershipRequest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load membership requests');
    }
  }

  Future<MembershipRequest> getMembershipRequestById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/membershipRequests/$id'));
    if (response.statusCode == 200) {
      return MembershipRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load membership request');
    }
  }

  Future<MembershipRequest> createMembershipRequest(MembershipRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/membershipRequests'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    print(response.body);
    if (response.statusCode == 201) {
      return MembershipRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create membership request');
    }
  }

  Future<MembershipRequest> updateMembershipRequest(String id, MembershipRequest request) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/membershipRequests/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return MembershipRequest.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update membership request');
    }
  }

  Future<void> deleteMembershipRequest(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/membershipRequests/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete membership request');
    }
  }

  Future<void> approveRequest(String id) async {
    final response = await http.post(Uri.parse('$baseUrl/membershipRequests/$id/approve'));
    // print("MembershipRequestService @65 ${response.body}");
    if (response.statusCode != 200) {
      throw Exception('Failed to approve membership request');
    }
  }

  Future<void> rejectRequest(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/membershipRequests/$id/reject'));
    print( response.request?.headers);
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to reject membership request');
    }
  }
}