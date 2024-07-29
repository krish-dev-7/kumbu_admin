// services/package_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kumbu_admin/Common/Constants.dart';
import '../Models/Package.dart';

class PackageService {
  static String baseUrl = BASE_URL; // Replace with your API base URL

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

  Future<void> addPackage(Package newPackage) async {
    String apiUrl = '$baseUrl/api/packages';
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newPackage.toJson()),
      );
      print(response.body);
      if (response.statusCode == 201) {
        // Package added successfully
        return;
      } else {
        throw Exception('Failed to add package');
      }
    } catch (e) {
      throw Exception('Error adding package: $e');
    }
  }
  Future<void> updatePackage(Package updatedPackage) async {
    String apiUrl = '$baseUrl/api/packages/${updatedPackage.packageID}';
    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedPackage.toJson()),
      );

      if (response.statusCode == 200) {
        // Package updated successfully
        return;
      } else {
        throw Exception('Failed to update package');
      }
    } catch (e) {
      throw Exception('Error updating package: $e');
    }
  }

  Future<void> deletePackage(String packageID) async {
    String apiUrl = '$baseUrl/api/packages/$packageID';
    try {
      var response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Package deleted successfully
        return;
      } else {
        throw Exception('Failed to delete package');
      }
    } catch (e) {
      throw Exception('Error deleting package: $e');
    }
  }

  Future<Package> getPackageById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/packages/$id'));
    if (response.statusCode == 200) {
      return Package.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load package');
    }
  }
}
