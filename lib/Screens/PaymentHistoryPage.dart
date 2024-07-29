import 'package:flutter/material.dart';
import '../Common/ThemeData.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import '../Models/PurchaseOrder.dart'; // Update path as per your project structure
import 'package:intl/intl.dart';

class PaymentHistoryPage extends StatelessWidget {
  final GymMember member;

  PaymentHistoryPage({required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${member.name}\'s Payment History'),
      ),
      body: member.purchaseOrderHistories.isEmpty
          ? Center(child: Text('No payment history found.'))
          : ListView.builder(
        itemCount: member.purchaseOrderHistories.length,
        itemBuilder: (context, index) {
          final purchaseOrder = member.purchaseOrderHistories[index] as PurchaseOrder;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              tileColor: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: appLightGreen, width: 1),
              ),
              title: Text(
                'Amount Paid: \₹${purchaseOrder.amountPaid.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: appLightGreen,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Package ID: ${purchaseOrder.packageId}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Time of Purchase: ${_formatDate(purchaseOrder.timeOfPO)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Membership Start Date: ${_formatDate(purchaseOrder.membershipStartDate)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Membership End Date: ${_formatDate(purchaseOrder.membershipEndDate)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(
                Icons.info,
                color: appLightGreen,
              ),
            ),
          );

        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
