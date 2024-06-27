import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:image_picker/image_picker.dart';

class AddMemberPage extends StatefulWidget {
  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController membershipDurationController = TextEditingController();
  final TextEditingController membershipStartDateController = TextEditingController();
  final TextEditingController membershipEndDateController = TextEditingController();
  final TextEditingController packageController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageUrlController.text = pickedFile.path; // Update controller with image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member', style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // For tablets and larger screens, use a two-column layout
            return _buildTwoColumnLayout(context);
          } else {
            // For smaller screens (like mobile), use a single-column layout
            return _buildSingleColumnLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildSingleColumnLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: getImage,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.account_circle, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.edit, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ), // Member Image
          SizedBox(height: 10),
          _buildTextField(context, 'Name', nameController),
          _buildTextField(context, 'Age', ageController),
          _buildTextField(context, 'Gender', genderController),
          _buildTextField(context, 'Email', emailController),
          _buildTextField(context, 'Phone Number', phoneNumberController),
          _buildTextField(context, 'Address', addressController),
          _buildPackageDropdown(context), // Package selection dropdown
          _buildTextField(context, 'Membership Duration', membershipDurationController),
          _buildDateField(context, 'Membership Start Date', membershipStartDateController),
          _buildDateField(context, 'Membership End Date', membershipEndDateController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveMemberDetails();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(appDarkGreen),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                ),
              ),
            ),
            child: Text(
              'Save Member',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColumnLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildFormFields(context),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: _image != null ? FileImage(_image!) : null,
                                child: _image == null
                                    ? Icon(Icons.account_circle, size: 50)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(Icons.edit, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildPackageDropdown(context), // Package selection dropdown
                      _buildTextField(context, 'Membership Duration', membershipDurationController),
                      _buildDateField(context, 'Membership Start Date', membershipStartDateController),
                      _buildDateField(context, 'Membership End Date', membershipEndDateController),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                _saveMemberDetails();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(appDarkGreen),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                  ),
                ),
              ),
              child: Text(
                'Save Member',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context) {
    return [
      _buildTextField(context, 'Name', nameController),
      _buildTextField(context, 'Age', ageController),
      _buildTextField(context, 'Gender', genderController),
      _buildTextField(context, 'Email', emailController),
      _buildTextField(context, 'Phone Number', phoneNumberController),
      _buildTextField(context, 'Address', addressController),
    ];
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appLightGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appLightGreen),
            ),
            fillColor: Colors.white10,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPackageDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select Package',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: packageController.text.isNotEmpty ? packageController.text : null,
          onChanged: (newValue) {
            setState(() {
              packageController.text = newValue!;
            });
          },
          items: <String>['Package A', 'Package B', 'Package C'] // Replace with actual package names
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
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
        ),
        SizedBox(height: 16),
      ],
    );
  }


  Widget _buildDateField(BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => _selectDate(context, controller),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: Icon(Icons.calendar_today, color: appLightGreen),
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: appLightGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: appLightGreen),
                ),
                fillColor: Colors.white10,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveMemberDetails() {
    // Validate inputs and save member details
    String imageUrl = imageUrlController.text;
    String name = nameController.text;
    int age = int.tryParse(ageController.text) ?? 0; // Handle parsing error as needed
    String gender = genderController.text;
    String email = emailController.text;
    String phoneNumber = phoneNumberController.text;
    String address = addressController.text;
    String membershipDuration = membershipDurationController.text;
    String membershipStartDate = membershipStartDateController.text;
    String membershipEndDate = membershipEndDateController.text;
    String selectedPackage = packageController.text; // Get selected package

    // Create a new GymMember object or update existing member
    GymMember newMember = GymMember(
      imageUrl: imageUrl,
      name: name,
      age: age,
      gender: gender,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      membershipDuration: membershipDuration,
      membershipStartDate: DateTime.parse(membershipStartDate),
      membershipEndDate: DateTime.parse(membershipEndDate),
      id: '', // Assign member ID as needed
      currentPackageID: selectedPackage, // Assign selected package
      level: MembershipLevel.BRONZE, // Example: Set membership level
      dietID: '', // Example: Set diet ID
      daysAttended: 0, // Example: Set days attended
    );

    // Handle saving or updating logic here (e.g., send to backend, save locally, etc.)
    // Example: Send newMember to API, save to database, etc.

    // Optionally, navigate back to previous screen after saving
    Navigator.pop(context);
  }
}
