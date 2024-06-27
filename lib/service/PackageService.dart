// services/package_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Package.dart';

class PackageService {
  static const String baseUrl = 'http://127.0.0.1:3000'; // Replace with your API base URL

  Future<List<Package>> getPackages() async {
    String apiUrl = '$baseUrl/api/packages'; // Replace with your specific endpoint
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Package> packages = body.map((dynamic item) => Package.fromJson(item)).toList();
        return packages;
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      throw Exception('Error fetching packages: $e');
    }
  }
}
