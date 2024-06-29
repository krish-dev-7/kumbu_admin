import 'package:flutter/material.dart';

import '../Models/Quotation.dart';
import '../service/QuotationService.dart';

class QuotationPage extends StatefulWidget {
  @override
  _QuotationPageState createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  final QuotationService _quotationService = QuotationService();
  late Future<List<Quotation>> _quotationsFuture;

  @override
  void initState() {
    super.initState();
    _quotationsFuture = _quotationService.fetchQuotations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotations'),
      ),
      body: FutureBuilder<List<Quotation>>(
        future: _quotationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quotations found.'));
          } else {
            List<Quotation> quotations = snapshot.data!;
            return ListView.builder(
              itemCount: quotations.length,
              itemBuilder: (context, index) {
                Quotation quotation = quotations[index];
                return ListTile(
                  title: Text('Requester: ${quotation.requesterName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Package: ${quotation.package.getReadableDuration()} - ${quotation.package.level}'),
                      Text('Amount: ₹${quotation.package.amount}'),
                      Text('Approved: ${quotation.isApproved ? 'Yes' : 'No'}'),
                      Text('Paid: ${quotation.isPaid ? 'Yes' : 'No'}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
