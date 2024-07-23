import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Diet.dart';

class DietService {
  final String apiUrl = 'https://kumbubackend.onrender.com/api/diets'; // Update with your API URL

  Future<List<Diet>> getAllDiets() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Diet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load diets');
    }
  }

  Future<void> addDiet(Diet diet) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(diet.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add diet');
    }
  }
}
