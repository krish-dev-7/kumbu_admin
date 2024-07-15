// services/workout_template_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/WorkoutTemplate.dart';

class WorkoutTemplateService {
  static const String baseUrl = 'http://127.0.0.1:3000/api/workoutTemplates';

  Future<List<WorkoutTemplate>> fetchWorkoutTemplates() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => WorkoutTemplate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load workout templates');
    }
  }

  Future<void> createWorkoutTemplate(WorkoutTemplate template) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(template.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create workout template');
    }
  }

  Future<void> updateWorkoutTemplate(WorkoutTemplate template) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${template.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(template.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update workout template');
    }
  }

  Future<void> deleteWorkoutTemplate(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete workout template');
    }
  }

  Future<void> assignWorkoutTemplate(String memberId, String workoutTemplateId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:3000/api/memberWorkoutTemplate/assign'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'memberId': memberId,
        'workoutTemplateId': workoutTemplateId,
      }),
    );

    print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to assign workout template');
    }
  }
}
