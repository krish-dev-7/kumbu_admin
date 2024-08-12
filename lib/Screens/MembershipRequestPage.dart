import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:kumbu_admin/Models/Package.dart';
import 'package:kumbu_admin/service/MembershipRequestService.dart';
import 'package:kumbu_admin/service/PackageService.dart';

import '../Models/MembershipRequest.dart';

class MembershipRequestsPage extends StatefulWidget {
  @override
  _MembershipRequestsPageState createState() => _MembershipRequestsPageState();
}

class _MembershipRequestsPageState extends State<MembershipRequestsPage> {
  late MembershipRequestService _membershipRequestService;
  late PackageService _packageService;
  late Future<List<MembershipRequest>> _membershipRequestsFuture;

  @override
  void initState() {
    super.initState();
    _membershipRequestService = MembershipRequestService(); // Replace 'YOUR_BASE_URL' with your backend URL
    _membershipRequestsFuture = _membershipRequestService.getAllMembershipRequests();
  }

  // Future<void> _fetchCurrentPackage(String packageID) async {
  //   try {
  //     // Replace 'PACKAGE_ID' with the actual package ID you need to fetch
  //     final package = await _packageService.getPackageById(packageID);
  //     setState(() {
  //       _currentPackage = package;
  //     });
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load package details')),
  //     );
  //   }
  // }

  Future<void> _approveRequest(String id) async {
    try {
      await _membershipRequestService.approveRequest(id);
      setState(() {
        _membershipRequestsFuture = _membershipRequestService.getAllMembershipRequests();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request approved successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve request')),
      );
    }
  }

  Future<void> _rejectRequest(String id) async {
    try {
      await _membershipRequestService.rejectRequest(id);
      setState(() {
        _membershipRequestsFuture = _membershipRequestService.getAllMembershipRequests();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request rejected successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Requests'),
      ),
      body: FutureBuilder<List<MembershipRequest>>(
        future: _membershipRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Contact tech team '));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No membership requests found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final request = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            request.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed:  () => _approveRequest(request.id!),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () => _rejectRequest(request.id!),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.grey, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              request.phoneNumber,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.grey, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Package Duration: ${request.currentPackageID?.getReadableDuration()}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.grey, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Start Date: ${request.membershipStartDate.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.grey, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'End Date: ${request.membershipEndDate.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: appMediumColor, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Amount: ${request.currentPackageID?.amount}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: appMediumColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.hiking, color: appMediumColor, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Personal Training: ${request.isPT ? "Yes" : "No"}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: appMediumColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.grey, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Requester: ${request.requesterName}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.grey, size: 16),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Requested on: ${request.requestedDate}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
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
