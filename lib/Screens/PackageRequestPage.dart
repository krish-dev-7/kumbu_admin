import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:kumbu_admin/service/PurchaseOrderService.dart';

import '../Models/PurchaseOrder.dart';
import '../Models/Quotation.dart';
import '../service/MemberService.dart';
import '../service/QuotationService.dart';

class QuotationPage extends StatefulWidget {
  @override
  _QuotationPageState createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  final QuotationService _quotationService = QuotationService();
  late Future<List<Quotation>> _quotationsFuture;
  bool showUnapproved = false;

  @override
  void initState() {
    super.initState();
    _fetchQuotations();
  }

  void _fetchQuotations() {
    _quotationsFuture = _quotationService.fetchQuotations();
  }

  void _toggleQuotations() {
    setState(() {
      showUnapproved = !showUnapproved;
    });
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
            print(snapshot.error);
            return Center(child: Text('Contact Devloper team'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quotations found.'));
          } else {
            List<Quotation> quotations = snapshot.data!;
            List<Quotation> filteredQuotations = quotations.where((quotation) {
              if (showUnapproved) {
                return !quotation.isApproved;
              } else {
                return quotation.isApproved && !quotation.isPaid;
              }
            }).toList();

            return Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         showUnapproved ? 'Unapproved' : 'Unpaid Approvals',
                //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                //       ),
                //       SizedBox(width: 15,),
                //       Transform.scale(
                //         scale: 1.5, // Adjust the scale value as needed
                //         child: Switch(
                //           value: showUnapproved,
                //           onChanged: (value) {
                //             _toggleQuotations();
                //           },
                //           activeColor: appLightGreen,
                //           inactiveThumbColor: appDarkGreen,
                //           inactiveTrackColor: appDarkGreen.withOpacity(0.5),
                //           activeTrackColor: appLightGreen.withOpacity(0.5),
                //         ),
                //       )
                //
                //     ],
                //   ),
                // ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
                      return GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredQuotations.length,
                        itemBuilder: (ctx, index) {
                          return QuotationCard(quotation: filteredQuotations[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


class QuotationCard extends StatefulWidget {
  final Quotation quotation;

  QuotationCard({required this.quotation});

  @override
  _QuotationCardState createState() => _QuotationCardState();
}

class _QuotationCardState extends State<QuotationCard> {
  final QuotationService _quotationService = QuotationService();
  final PurchaseOrderService _purchaseOrderService = new PurchaseOrderService();

  void _approveQuotation() async {
    try {
      await _quotationService.approveQuotation(widget.quotation.quotationID);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quotation approved successfully')),
      );
      // Optionally, refresh the list or update the state
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QuotationPage()));
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve quotation: $error')),
      );
    }
  }

  void _paidQuotation() async {
    try {
      await _quotationService.paidQuotation(widget.quotation.quotationID);
      PurchaseOrder purchaseOrder = PurchaseOrder(
        memberId: widget.quotation.requesterUID,
        gymMemberID: widget.quotation.requesterID,
        packageId: widget.quotation.package.packageID??"",
        timeOfPO: DateTime.now(),
        amountPaid: widget.quotation.package.amount, membershipStartDate: DateTime.now(), membershipEndDate: DateTime.now().add(Duration(days: widget.quotation.package.packageDuration)), purchaseOrderId: '',
      );
      await _purchaseOrderService.addPurchaseOrder(purchaseOrder);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quotation approved successfully')),
      );

      await MemberService().updateMembershipDetails(
        widget.quotation.requesterUID,
        widget.quotation.package.packageID ?? "",
        DateTime.now().add(Duration(days: widget.quotation.package.packageDuration)),
      );
      // Optionally, refresh the list or update the state
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QuotationPage()));
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve quotation: $error')),
      );
    }
  }

  void _rejectQuotation() async {
    try {
      await _quotationService.deleteQuotation(widget.quotation.quotationID);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quotation rejected successfully')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QuotationPage()));

    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject quotation: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: appLightGreen,
          width: 1,
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Requester: ${widget.quotation.requesterName}',
              style: TextStyle(fontWeight: FontWeight.bold, color: appLightGreen),
            ),
            SizedBox(height: 5),
            Text('Level: ${widget.quotation.package.level}'),
            Text('Duration: ${widget.quotation.package.getReadableDuration()}'),
            Text('Amount: \$${widget.quotation.package.amount.toStringAsFixed(2)}'),
            Text('Phone: ${widget.quotation.requesterNumber}'),
            Text('Approved: ${widget.quotation.isApproved ? 'Yes' : 'No'}'),
            if (widget.quotation.isApproved && !widget.quotation.isPaid) ...[
              Text('Paid: ${widget.quotation.isPaid ? 'Yes' : 'No'}'),
            ],
            if (!widget.quotation.isApproved) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _rejectQuotation,
                    icon: Icon(Icons.close, color: Colors.white),
                    label: Text('Reject', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _approveQuotation,
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text('Approve', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800], // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (widget.quotation.isApproved && !widget.quotation.isPaid) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _rejectQuotation,
                    icon: Icon(Icons.close, color: Colors.white),
                    label: Text('Cancel', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _paidQuotation,
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text('Paid', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800], // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}


