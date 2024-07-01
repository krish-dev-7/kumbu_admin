import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumbu_admin/service/DietTemplateService.dart';
import '../Models/DietTemplate.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'PaymentHistoryPage.dart'; // Import the new page
import '../service/MemberService.dart'; // Import MemberService

class MemberDetailsPage extends StatefulWidget {
  final GymMember member;

  MemberDetailsPage({required this.member});

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  MemberService _memberService = MemberService();
  late List<DietTemplate> _dietTemplates = []; // List to hold fetched diet templates
  String? _selectedDietTemplateId; // Selected diet template ID

  @override
  void initState() {
    super.initState();
    _fetchDietTemplates(); // Fetch diet templates when page initializes
  }

  Future<void> _fetchDietTemplates() async {
    try {
      List<DietTemplate> dietTemplates = await DietTemplateService().fetchDietTemplates();
      setState(() {
        _dietTemplates = dietTemplates;
      });
    } catch (e) {
      print('Failed to fetch diet templates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member.name),
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
                  backgroundImage: widget.member.imageUrl != null
                      ? NetworkImage(widget.member.imageUrl!)
                      : null,
                  child: widget.member.imageUrl == null
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
                  _buildSection(context, 'Diet Assignment', _buildDietAssignmentSection()),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentHistoryPage(member: widget.member),
                    ),
                  );
                },
                child: Text('View Payment History', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: appLightGreen),
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
      _buildDetailRow(Icons.person, 'Name', widget.member.name),
      _buildDetailRow(Icons.cake, 'Age', widget.member.age.toString()),
      _buildDetailRow(Icons.wc, 'Gender', widget.member.gender),
      _buildDetailRow(Icons.email, 'Email', widget.member.email),
      _buildDetailRow(Icons.phone, 'Phone Number', widget.member.phoneNumber),
      _buildDetailRow(Icons.home, 'Address', widget.member.address),
    ]);
  }

  Widget _buildMembershipDetailsTable() {
    return _buildDetailTable([
      _buildDetailRow(Icons.access_time, 'Membership Duration', widget.member.getMembershipDuration()),
      _buildDetailRow(Icons.calendar_today, 'Membership Start Date', _formatDate(widget.member.membershipStartDate)),
      _buildDetailRow(Icons.calendar_today, 'Membership End Date', _formatDate(widget.member.membershipEndDate)),
    ]);
  }

  Widget _buildPackageDetails() {
    return _buildDetailTable([
      _buildDetailRow(Icons.star, 'Package ID', widget.member.currentPackage?.packageID ?? 'N/A'),
      _buildDetailRow(Icons.timer, 'Duration', '${widget.member.currentPackage?.packageDuration ?? 'N/A'} days'),
      _buildDetailRow(Icons.label, 'Level', widget.member.currentPackage?.level ?? 'N/A'),
      _buildDetailRow(Icons.monetization_on, 'Amount',
          widget.member.currentPackage != null ? '\$${widget.member.currentPackage!.amount.toStringAsFixed(2)}' : 'N/A'),
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

  Widget _buildDietAssignmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Diet Template',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: appLightGreen, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: appLightGreen, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: appLightGreen, width: 1.0),
            ),
          ),
          value: _selectedDietTemplateId,
          onChanged: (newValue) {
            setState(() {
              _selectedDietTemplateId = newValue;
            });
          },
          items: _dietTemplates.map((template) {
            return DropdownMenuItem<String>(
              value: template.templateID,
              child: Text(template.templateName),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
         ...[
          Text(
            'Selected Diet Template:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appLightGreen,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _dietTemplates.firstWhere(
                  (template) => template.templateID == widget.member.dietTemplateID,
              orElse: () => DietTemplate(templateID: '', templateName: 'None Selected', diets: []),
            ).templateName,
          ),
        ],
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            if (_selectedDietTemplateId != null) {
              try {
                await _memberService.updateDietTemplateId(widget.member.id, _selectedDietTemplateId!);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Diet template assigned successfully'),
                  backgroundColor: Colors.green,
                ));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to assign diet template: $e'),
                  backgroundColor: Colors.red,
                ));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please select a diet template'),
                backgroundColor: Colors.orange,
              ));
            }
          },
          child: Text('Assign Diet Template', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: appLightGreen),
        ),
      ],
    );
  }
}
