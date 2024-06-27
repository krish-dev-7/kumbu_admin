import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'package:kumbu_admin/Common/ThemeData.dart';

class MemberDetailsPage extends StatelessWidget {
  final GymMember member;

  MemberDetailsPage({required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: member.imageUrl != null
                      ? NetworkImage(member.imageUrl!)
                      : null,
                  child: member.imageUrl == null
                      ? Icon(Icons.account_circle, size: 60)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  _buildSection(context, 'Personal Information', _buildPersonalInfoTable()),
                  _buildSection(context, 'Membership Details', _buildMembershipDetailsTable()),
                  _buildSection(context, 'Package Details', _buildPackageDetails()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sectionWidth = screenWidth > 600 ? screenWidth / 2 - 32 : screenWidth;

    return Container(
      width: sectionWidth,
      decoration: BoxDecoration(
        border: Border.all(color: appLightGreen, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appLightGreen,
            ),
          ),
          SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTable() {
    return _buildDetailTable([
      _buildDetailRow(Icons.person, 'Name', member.name),
      _buildDetailRow(Icons.cake, 'Age', member.age.toString()),
      _buildDetailRow(Icons.wc, 'Gender', member.gender),
      _buildDetailRow(Icons.email, 'Email', member.email),
      _buildDetailRow(Icons.phone, 'Phone Number', member.phoneNumber),
      _buildDetailRow(Icons.home, 'Address', member.address),
    ]);
  }

  Widget _buildMembershipDetailsTable() {
    return _buildDetailTable([
      _buildDetailRow(Icons.access_time, 'Membership Duration', member.membershipDuration),
      _buildDetailRow(Icons.calendar_today, 'Membership Start Date', _formatDate(member.membershipStartDate)),
      _buildDetailRow(Icons.calendar_today, 'Membership End Date', _formatDate(member.membershipEndDate)),
    ]);
  }

  Widget _buildPackageDetails() {
    return _buildDetailTable([
      _buildDetailRow(Icons.star, 'Package', member.currentPackageID ?? 'N/A'),
    ]);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat.yMMMd().format(date);
  }

  Widget _buildDetailTable(List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: appLightGreen),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
