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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No membership requests found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final request = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(request.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('name: ${request.name}'),
                        Text('Phone: ${request.phoneNumber}'),
                        Text('Package duration: ${request.currentPackageID?.getReadableDuration()}'),
                        Text('Start Date: ${request.membershipStartDate.toLocal()}'),
                        Text('End Date: ${request.membershipEndDate.toLocal()}'),
                        Text('Amount: ${request.currentPackageID?.amount}',style: TextStyle(color: appLightGreen),)
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _approveRequest(request.id!),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => _rejectRequest(request.id!),
                        ),
                      ],
                    ),
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
