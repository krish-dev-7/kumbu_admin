import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumbu_admin/Common/Constants.dart';

import '../Models/GymEvent.dart';

class GymEventService {
  final String baseUrl = '$BASE_URL/api';

  Future<List<GymEvent>> getAllEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((event) => GymEvent.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> createEvent(GymEvent event) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create event');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$eventId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }
}

