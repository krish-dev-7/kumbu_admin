import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumbu_admin/service/DietTemplateService.dart';
import '../Models/DietTemplate.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'package:kumbu_admin/Common/ThemeData.dart';
import '../Models/Package.dart';
import '../Models/PurchaseOrder.dart';
import '../service/PackageService.dart';
import '../service/PurchaseOrderService.dart';
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
  late List<DietTemplate> _dietTemplates = [];
  String? _selectedDietTemplateId;
  bool _isEditing = false;
  List<Package> _packages = [];

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _membershipStartDateController;
  late TextEditingController _membershipEndDateController;

  Package? _selectedPackage ;

  @override
  void initState() {
    super.initState();
    _fetchDietTemplates();
    _fetchPackages();


    // Initialize controllers with existing member data
    _nameController = TextEditingController(text: widget.member.name);
    _ageController = TextEditingController(text: widget.member.age.toString());
    _genderController = TextEditingController(text: widget.member.gender);
    _emailController = TextEditingController(text: widget.member.email);
    _phoneNumberController = TextEditingController(text: widget.member.phoneNumber);
    _addressController = TextEditingController(text: widget.member.address);
    _membershipStartDateController = TextEditingController(text: _formatDate(widget.member.membershipStartDate));
    _membershipEndDateController = TextEditingController(text: _formatDate(widget.member.membershipEndDate));
    // _selectedPackage = widget.member.currentPackage!;
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
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit, size: 40,),
            onPressed: _isEditing ? _saveChanges : _toggleEditing,
          ),
        ],
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
      _buildEditableDetailRow(Icons.person, 'Name', _nameController),
      _buildEditableDetailRow(Icons.cake, 'Age', _ageController, isNumber: true),
      _buildEditableDetailRow(Icons.wc, 'Gender', _genderController),
      _buildEditableDetailRow(Icons.email, 'Email', _emailController),
      _buildEditableDetailRow(Icons.phone, 'Phone Number', _phoneNumberController),
      _buildEditableDetailRow(Icons.home, 'Address', _addressController),
    ]);
  }

  Widget _buildMembershipDetailsTable() {
    if (_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDatePickerRow(Icons.calendar_today, 'Membership Start Date', _membershipStartDateController),
          _buildDatePickerRow(Icons.calendar_today, 'Membership End Date', _membershipEndDateController),
        ],
      );
    } else {
      return _buildDetailTable([
        _buildDetailRow(Icons.access_time, 'Membership Duration', widget.member.getMembershipDuration()),
        _buildDetailRow(Icons.calendar_today, 'Membership Start Date', _formatDate(widget.member.membershipStartDate)),
        _buildDetailRow(Icons.calendar_today, 'Membership End Date', _formatDate(widget.member.membershipEndDate)),
      ]);
    }
  }

  Widget _buildDatePickerRow(IconData icon, String label, TextEditingController controller) {
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
            child: InkWell(
              onTap: () => _selectDate(context, controller),
              child: IgnorePointer(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Widget _buildPackageDetails() {
    return (_isEditing)
        ?DropdownButtonFormField<Package>(
      value: _selectedPackage,
      hint: Text('Select Package'),
      onChanged: (Package? newValue) {
        setState(() {
          _selectedPackage = newValue!;
        });
      },
      items: _packages.map((Package package) {
        return DropdownMenuItem<Package>(
          value: package,
          child: Text('${package.level} - ${package.getReadableDuration()} - \₹${package.amount}'),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: appLightGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appLightGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appLightGreen),
        ),
        fillColor: Colors.white10,
      ),
    )
        :_buildDetailTable([
      _buildDetailRow(Icons.star, 'Package ID', widget.member.currentPackage?.packageID ?? 'N/A'),
      _buildDetailRow(Icons.timer, 'Duration', '${widget.member.currentPackage?.packageDuration ?? 'N/A'} days'),
      _buildDetailRow(Icons.label, 'Level', widget.member.currentPackage?.level ?? 'N/A'),
      _buildDetailRow(Icons.monetization_on, 'Amount',
          widget.member.currentPackage != null ? '\$${widget.member.currentPackage!.amount.toStringAsFixed(2)}' : 'N/A'),
    ]);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('yyyy-MM-dd').format(date);
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



  Widget _buildEditableDetailRow(IconData icon, String label, TextEditingController controller, {bool isNumber = false}) {
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
            child: _isEditing
                ? TextField(
              controller: controller,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
              style: TextStyle(color: Colors.white70),
            )
                : Text(
              controller.text,
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
        Text(
          'Selected Diet:',
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
          style: TextStyle(color: Colors.white70),
        ),
        // if (_isEditing)
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
            child: Text('Assign Diet', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: appLightGreen),
          ),
      ],
    );
  }
  Future<void> _fetchPackages() async {
    try {
      PackageService packageService = PackageService();
      List<Package> fetchedPackages = await packageService.getPackages();
      setState(() {
        _packages = fetchedPackages;
      });
    } catch (e) {
      // Handle error
      print('Error fetching packages: $e');
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    // Save the changes to the member details
    try {
      // Update the member object with new details
      widget.member.name = _nameController.text;
      widget.member.age = int.parse(_ageController.text);
      widget.member.gender = _genderController.text;
      widget.member.email = _emailController.text;
      widget.member.phoneNumber = _phoneNumberController.text;
      widget.member.address = _addressController.text;
      widget.member.membershipStartDate = DateTime.parse(_membershipStartDateController.text);
      widget.member.membershipEndDate = DateTime.parse(_membershipEndDateController.text);

      // Check if package is changed
      bool packageChanged = _selectedPackage?.packageID != widget.member.currentPackage?.packageID;
      print(packageChanged);
      print(_selectedPackage?.packageID);
      print(widget.member.currentPackage?.packageID);
      widget.member.currentPackage = _selectedPackage ?? widget.member.currentPackage;

      if (packageChanged) {
        // Show confirmation dialog
        bool confirmPurchaseHistory = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Payment History Addition'),
              content: Text('Do you want to add payment history for the new package?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false if not confirmed
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true if confirmed
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );

        if (confirmPurchaseHistory == true) {
          // Call service to add purchase history
          await _addPurchaseOrderHistory(widget.member.membershipStartDate, widget.member.membershipEndDate);
        }
      }

      // Call the service to update member details in the backend
      await _memberService.updateMember(widget.member);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Member details updated successfully'),
        backgroundColor: Colors.green,
      ));

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update member details: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _addPurchaseOrderHistory(DateTime startDate, DateTime endDate) async {
    try {
      // Create a new purchase order history object
      PurchaseOrder purchaseOrder = PurchaseOrder(
        memberId: widget.member.id,
        gymMemberID: widget.member.gymMemberID,
        packageId: _selectedPackage!.packageID??widget.member.currentPackage!.packageID??"",
        timeOfPO: DateTime.now(),
        amountPaid: _selectedPackage!.amount, membershipStartDate: startDate, membershipEndDate: endDate, purchaseOrderId: '',
      );

      // Call the service to add purchase order history
      await PurchaseOrderService().addPurchaseOrder(purchaseOrder);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Purchase history added successfully'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add purchase history: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

}
