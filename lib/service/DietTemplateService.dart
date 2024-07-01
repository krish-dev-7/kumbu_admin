import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/DietTemplate.dart';

class DietTemplateService {
  final String apiUrl = 'http://localhost:3000/api'; // Update with your API URL

  Future<List<DietTemplate>> fetchDietTemplates() async {
    final response = await http.get(Uri.parse('$apiUrl/dietTemplates'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<DietTemplate> dietTemplates = body
          .map((dynamic item) => DietTemplate.fromJson(item))
          .toList();
      return dietTemplates;
    } else {
      throw Exception('Failed to load diet templates');
    }
  }

  Future<void> addDietTemplate(DietTemplate dietTemplate) async {
    final response = await http.post(
      Uri.parse('$apiUrl/dietTemplates'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dietTemplate.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add diet template');
    }
  }
}
