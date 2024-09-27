import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumbu_admin/Common/config.dart';
import 'package:kumbu_admin/Models/MembershipRequest.dart';
import 'package:kumbu_admin/service/MembershipRequestService.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/Package.dart';
import '../service/MemberService.dart';
import '../service/PackageService.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController gymMemberIDController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  // final TextEditingController membershipDurationController = TextEditingController();
  final TextEditingController membershipStartDateController =
      TextEditingController();
  final TextEditingController membershipEndDateController =
      TextEditingController();
  final TextEditingController packageController = TextEditingController();
  bool isPT = false;

  void initializeControllersForTesting() {
    imageUrlController.text = "";
    nameController.text = "name";
    ageController.text = "29";
    genderController.text = "Male";
    emailController.text = "test@test.com";
    phoneNumberController.text = "0398203982";
    addressController.text = "test address";
    membershipStartDateController.text = "2024-07-29";
    membershipEndDateController.text = "2024-08-29";
  }

  File? _image;
  final picker = ImagePicker();
  final MemberService _memberService = MemberService();
  final MembershipRequestService _membershipRequestService =
      MembershipRequestService();
  List<Package> _packages = [];
  Package? _selectedPackage;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageUrlController.text =
            pickedFile.path; // Update controller with image path
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPackages();
    // initializeControllersForTesting();
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
        title: Text('Add Member',
            style: Theme.of(context).appBarTheme.titleTextStyle),
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
      padding: const EdgeInsets.all(16),
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
                        ? const Icon(Icons.account_circle, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.edit, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ), // Member Image
          const SizedBox(height: 10),
          _buildTextField(context, 'Member ID', gymMemberIDController),
          _buildTextField(context, 'Name', nameController),
          _buildTextField(context, 'Age', ageController),
          _buildTextField(context, 'Gender', genderController),
          _buildTextField(context, 'Email', emailController),
          _buildTextField(context, 'Phone Number', phoneNumberController),
          _buildTextField(context, 'Address', addressController),
          _buildTextField(context, 'Notes', notesController),
          _buildPackageDropdown(context), // Package selection dropdown
          _buildDateField(
              context, 'Membership Start Date', membershipStartDateController),
          _buildDateField(
              context, 'Membership End Date', membershipEndDateController),
          Row(
            children: [
              Checkbox(
                value: isPT,
                onChanged: (bool? value) {
                  setState(() {
                    isPT = value ?? false;
                  });
                },
              ),
              Text("Personal training"),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _saveMemberDetails();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(appDarkGreen),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the radius as needed
                ),
              ),
            ),
            child: const Text(
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              const SizedBox(width: 16),
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
                                backgroundImage:
                                    _image != null ? FileImage(_image!) : null,
                                child: _image == null
                                    ? const Icon(Icons.account_circle, size: 50)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  child: const Icon(Icons.edit,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: isPT,
                            onChanged: (bool? value) {
                              setState(() {
                                isPT = value ?? false;
                              });
                            },
                          ),
                          Text("Personal Training"),
                        ],
                      ),

                      _buildPackageDropdown(
                          context), // Package selection dropdown
                      _buildDateField(context, 'Membership Start Date',
                          membershipStartDateController),
                      _buildDateField(context, 'Membership End Date',
                          membershipEndDateController),
                      const SizedBox(height: 20),
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
                    borderRadius: BorderRadius.circular(
                        20), // Adjust the radius as needed
                  ),
                ),
              ),
              child: const Text(
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
      _buildTextField(context, 'Member ID', gymMemberIDController),
      _buildTextField(context, 'Name', nameController),
      _buildTextField(context, 'Age', ageController),
      _buildTextField(context, 'Gender', genderController),
      _buildTextField(context, 'Email', emailController),
      _buildTextField(context, 'Phone Number', phoneNumberController),
      _buildTextField(context, 'Address', addressController),
      _buildTextField(context, 'Notes', notesController),
    ];
  }

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle:  TextStyle(color: appLightGreen),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appLightGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appLightGreen),
            ),
            fillColor: Colors.white10,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPackageDropdown(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<Package>(
          value: _selectedPackage,
          hint: const Text('Select Package'),
          onChanged: (Package? newValue) {
            setState(() {
              _selectedPackage = newValue;
              packageController.text = newValue?.packageID ?? '';
            });
          },
          items: _packages.map((Package package) {
            return DropdownMenuItem<Package>(
              value: package,
              child: Text(
                  '${package.level} - ${package.getReadableDuration()} - ₹${package.amount}'),
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
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, TextEditingController controller) {
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
                labelStyle: TextStyle(color: appLightGreen),
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
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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

  void _saveMemberDetails() async {
    // Validate inputs and save member details

    // if (_image == null) return;

    try {
      // Upload image to Firebase Storage
      String imageUrl ="";
      if (_image != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profilePic')
            .child('${emailController.text}.jpg');

        final UploadTask uploadTask = storageRef.putFile(_image!);
        final TaskSnapshot storageSnapshot = await uploadTask;

        // Get the download URL of the uploaded image
        final String downloadUrl = await storageSnapshot.ref.getDownloadURL();
        imageUrl = downloadUrl;
      }


      int gymMemberID = int.tryParse(gymMemberIDController.text)??0;
      String name = nameController.text;
      int age = int.tryParse(ageController.text) ??
          0; // Handle parsing error as needed
      String gender = genderController.text;
      String email = emailController.text;
      String phoneNumber = phoneNumberController.text;
      String address = addressController.text;
      String notes = notesController.text;
      String membershipDuration = _selectedPackage!.getReadableDuration();
      String membershipStartDate = membershipStartDateController.text;
      String membershipEndDate = membershipEndDateController.text;
      String selectedPackage = packageController.text; // Get selected package
      // Create a new GymMember object or update existing member
      GymMember newMember = GymMember(
        imageUrl: imageUrl,
        isPT: isPT,
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
        gymMemberID: gymMemberID,
        currentPackage: _selectedPackage, // Assign selected package
        level: MembershipLevel.BRONZE, // Example: Set membership level
        dietTemplateID: "", // Example: Set diet ID
        daysAttended: 0, // Example: Set days attended
        notes: notes
      );

      print(user?.role);
      if(user?.role=="Admin"){
      _memberService.addMember(
          newMember); // Await if you need to handle response or errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully')),
      );}
      else{
        _addMemberRequest(MembershipRequest.fromGymMember(newMember, user!.id, user!.name));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add member: $e')),
      );
    }
  }

  void _addMemberRequest(MembershipRequest newMemberRequest) {
    try {
      _membershipRequestService.createMembershipRequest(
          newMemberRequest); // Await if you need to handle response or errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Requested successfully')),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to request')),
      );
    }
  }
}
