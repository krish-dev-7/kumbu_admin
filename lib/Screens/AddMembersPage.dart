import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/Package.dart';
import '../service/MemberService.dart';
import '../service/PackageService.dart';

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
  // final TextEditingController membershipDurationController = TextEditingController();
  final TextEditingController membershipStartDateController = TextEditingController();
  final TextEditingController membershipEndDateController = TextEditingController();
  final TextEditingController packageController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  final MemberService _memberService = MemberService();
  List<Package> _packages = [];
  Package? _selectedPackage;


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
  void initState() {
    super.initState();
    _fetchPackages();
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
          _buildDateField(context, 'Membership Start Date', membershipStartDateController),
          _buildDateField(context, 'Membership End Date', membershipEndDateController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveMemberDetails();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(appDarkGreen),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                backgroundColor: WidgetStateProperty.all<Color>(appDarkGreen),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
      children: [
        DropdownButtonFormField<Package>(
          value: _selectedPackage,
          hint: Text('Select Package'),
          onChanged: (Package? newValue) {
            setState(() {
              _selectedPackage = newValue;
              packageController.text = newValue?.packageID ?? '';
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
        ),
        SizedBox(height: 16,)
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

  void _saveMemberDetails() async{
    // Validate inputs and save member details

    if (_image == null) return;

    try {
      // Upload image to Firebase Storage
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profilePic')
          .child('${emailController.text}.jpg');

      final UploadTask uploadTask = storageRef.putFile(_image!);
      final TaskSnapshot storageSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

      String imageUrl = downloadUrl;
      String name = nameController.text;
      int age = int.tryParse(ageController.text) ?? 0; // Handle parsing error as needed
      String gender = genderController.text;
      String email = emailController.text;
      String phoneNumber = phoneNumberController.text;
      String address = addressController.text;
      String membershipDuration = _selectedPackage!.getReadableDuration();
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
        gymMemberID: 0,
        currentPackage: _selectedPackage, // Assign selected package
        level: MembershipLevel.BRONZE, // Example: Set membership level
        dietTemplateID: "", // Example: Set diet ID
        daysAttended: 0, // Example: Set days attended
      );

      _memberService.addMember(newMember); // Await if you need to handle response or errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add member: $e')),
      );
    }
    // Navigator.pop(context);
  }
}
