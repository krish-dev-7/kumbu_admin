import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/Quotation.dart'; // Adjust path as needed

class QuotationService {
  static const String baseUrl = 'http://localhost:3000'; // Replace with your API base URL

  Future<List<Quotation>> fetchQuotations() async {
    String apiUrl = '$baseUrl/api/quotations'; // Replace with your specific endpoint
    try {
      var response = await http.get(Uri.parse(apiUrl));
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Quotation> quotations = jsonList.map((e) => Quotation.fromJson(e)).toList();
        return quotations;
      } else {
        throw Exception('Failed to fetch quotations');
      }
    } catch (e) {
      throw Exception('Error fetching quotations: $e');
    }
  }

  Future<void> approveQuotation(String quotationID) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/quotations/$quotationID'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'isApproved': true}),
    );
    // print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to approve quotation');
    }
  }

  Future<void> paidQuotation(String quotationID) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/quotations/$quotationID'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'isPaid': true}),
    );
    // print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to approve quotation');
    }
  }

  Future<void> deleteQuotation(String quotationID) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/quotations/$quotationID'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete quotation');
    }
  }
}
