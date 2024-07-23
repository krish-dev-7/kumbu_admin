import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Attendance.dart';

class AttendanceService {
  final String _baseUrl = 'https://kumbubackend.onrender.com/api';

  Future<List<Attendance>> getAttendanceByDate(DateTime date) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/attendance/date/${date.toIso8601String().split('T')[0]}'),
    );

    print("Attendance response: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load attendance records');
    }
  }
  Future<List<Attendance>> getAttendanceByMember(String memberId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/attendance/member/$memberId'),
    );

    print("Attendance by member response: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load attendance records');
    }
  }
}
