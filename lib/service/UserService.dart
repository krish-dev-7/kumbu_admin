import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumbu_admin/Common/Constants.dart';
import 'package:kumbu_admin/Common/config.dart';

import '../Models/MembershipRequest.dart';
import '../Models/User.dart';

class UserService {
  final String baseUrl = "${BASE_URL}/api";

  Future<List<AppUser>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => AppUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<AppUser> getUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return user!;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<AppUser> createUser(AppUser user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return AppUser.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<AppUser> updateUser(String id, AppUser user) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return AppUser.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  Future<AppUser?> getUserByEmail(String email) async {
    final url = '$baseUrl/users/email/$email';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      user = AppUser.fromJson(json.decode(response.body));
      return user;
    } else {
      return null;
    }
  }
}
