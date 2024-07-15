import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import '../Models/PurchaseOrder.dart'; // Update with your PurchaseOrder model path
import '../service/PurchaseOrderService.dart'; // Import your PurchaseOrderService

class GlobalPaymentHistoryPage extends StatefulWidget {
  @override
  _GlobalPaymentHistoryPageState createState() => _GlobalPaymentHistoryPageState();
}

class _GlobalPaymentHistoryPageState extends State<GlobalPaymentHistoryPage> {
  PurchaseOrderService _purchaseOrderService = PurchaseOrderService();
  List<PurchaseOrder> _purchaseOrders=[];

  @override
  void initState() {
    super.initState();
    _fetchPurchaseOrders();
  }

  Future<void> _fetchPurchaseOrders() async {
    try {
      List<PurchaseOrder> purchaseOrders = await _purchaseOrderService.fetchAllPurchaseOrders();
      setState(() {
        _purchaseOrders = purchaseOrders;
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch purchase orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Payment Histories'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Calculate monthly total income
    double monthlyTotal = 0;
    if (_purchaseOrders.isNotEmpty) {
      // Get current month and year
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;

      // Filter purchase orders for the current month and year
      List<PurchaseOrder> filteredOrders = _purchaseOrders.where((order) =>
      order.timeOfPO.month == currentMonth && order.timeOfPO.year == currentYear).toList();

      // Calculate monthly total income
      monthlyTotal = filteredOrders.fold(0, (sum, order) => sum + order.amountPaid);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Monthly Total Income: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Text(
                '\₹${monthlyTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appLightGreen,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _purchaseOrders.isEmpty
              ? const Center(
            child: Text("No history"),
          )
              : ListView.builder(
            itemCount: _purchaseOrders.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(color: appLightGreen,height: 1,),
                  ),
                  ListTile(
                    title: Text('Member ID: ${_purchaseOrders[index].gymMemberID}'),
                    subtitle: Text('Amount: \₹${_purchaseOrders[index].amountPaid.toStringAsFixed(2)}'),
                    // Add more details as needed
                  ),
                  // Divider(color: appLightGreen,)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

}
