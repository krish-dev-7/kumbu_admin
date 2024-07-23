import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/PurchaseOrder.dart'; // Update with your PurchaseOrder model path

class PurchaseOrderService {
  static const String baseUrl = 'https://kumbubackend.onrender.com/api'; // Update with your API base URL

  Future<List<PurchaseOrder>> fetchAllPurchaseOrders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/purchaseOrders'));

      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<PurchaseOrder> purchaseOrders = data.map((item) => PurchaseOrder.fromMap(item)).toList();
        return purchaseOrders;
      } else {
        // Handle other status codes
        print('Failed to fetch purchase orders.: ${response.body}');
        throw Exception('Failed to fetch purchase orders');
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error fetching purchase orders: $e');
      throw Exception('Error fetching purchase orders: $e');
    }
  }
  Future<void> addPurchaseOrder(PurchaseOrder purchaseOrder) async {
    try {
      print(purchaseOrder.toMap());
      final response = await http.post(
        Uri.parse('$baseUrl/purchaseOrders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(purchaseOrder.toMap()),
      );

      print(response.body);

      if (response.statusCode == 201) {
        // Success
        print('Purchase order added successfully');
      } else {
        // Handle other status codes
        print('Failed to add purchase order. ${response.body}');
        throw Exception('Failed to add purchase order');
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error adding purchase order: $e');
      throw Exception('Error adding purchase order: $e');
    }
  }
}
