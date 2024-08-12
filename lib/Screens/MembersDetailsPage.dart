import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kumbu_admin/Common/config.dart';
import 'package:kumbu_admin/Screens/MembersAttendancePage.dart';
import 'package:kumbu_admin/service/DietTemplateService.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Models/DietTemplate.dart';
import '../Models/Member.dart'; // Update path as per your project structure
import 'package:kumbu_admin/Common/ThemeData.dart';
import '../Models/Package.dart';
import '../Models/PurchaseOrder.dart';
import '../Models/WorkoutTemplate.dart';
import '../service/PackageService.dart';
import '../service/PurchaseOrderService.dart';
import '../service/WorkoutTemplateService.dart';
import 'PaymentHistoryPage.dart'; // Import the new page
import '../service/MemberService.dart'; // Import MemberService

class MemberDetailsPage extends StatefulWidget {
  final GymMember member;

  const MemberDetailsPage({super.key, required this.member});

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  final MemberService _memberService = MemberService();
  final WorkoutTemplateService _workoutService = WorkoutTemplateService();
  late List<DietTemplate> _dietTemplates = [];
  String? _selectedDietTemplateId;
  bool _isEditing = false;
  List<Package> _packages = [];
  MembershipLevel? _selectedLevel;
  File? _image;
  String? _imgUrl;
  get data => null;

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _membershipStartDateController;
  late TextEditingController _membershipEndDateController;
  final TextEditingController imageUrlController = TextEditingController();

  Package? _selectedPackage;
  late bool isPT;

  @override
  void initState() {
    super.initState();
    _fetchDietTemplates();
    _fetchPackages();
    _fetchWorkoutTemplates();

    // Initialize controllers with existing member data
    _nameController = TextEditingController(text: widget.member.name);
    _selectedLevel = widget.member.level;
    _imgUrl = widget.member.imageUrl;


    _ageController = TextEditingController(text: widget.member.age.toString());
    _genderController = TextEditingController(text: widget.member.gender);
    _emailController = TextEditingController(text: widget.member.email);
    _phoneNumberController =
        TextEditingController(text: widget.member.phoneNumber);
    _addressController = TextEditingController(text: widget.member.address);
    _membershipStartDateController = TextEditingController(
        text: _formatDate(widget.member.membershipStartDate));
    _membershipEndDateController = TextEditingController(
        text: _formatDate(widget.member.membershipEndDate));
    isPT = widget.member.isPT;
    // _selectedPackage = widget.member.currentPackage!;
  }

  Future<void> _fetchDietTemplates() async {
    try {
      List<DietTemplate> dietTemplates =
          await DietTemplateService().fetchDietTemplates();
      setState(() {
        _dietTemplates = dietTemplates;
      });
    } catch (e) {
      print('Failed to fetch diet templates: $e');
    }
  }

  double calculateProgress(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('End date must be after start date');
    }

    final now = DateTime.now();
    final totalDuration = endDate.difference(startDate).inMilliseconds;

    final elapsedDuration = now.difference(startDate).inMilliseconds;

    if (elapsedDuration <= 0) {
      return 0.0;
    } else if (elapsedDuration >= totalDuration) {
      return 1.0;
    } else {
      return elapsedDuration / totalDuration;
    }
  }

  Future<void> _fetchWorkoutTemplates() async {
    try {
      List<WorkoutTemplate> workoutTemplates =
          await _workoutService.fetchWorkoutTemplates();
      setState(() {
        _workoutTemplates = workoutTemplates;
      });
    } catch (e) {
      print('Failed to fetch diet templates: $e');
    }
  }

  String? _selectedWorkoutTemplateId;
  List<WorkoutTemplate> _workoutTemplates = [];

  void _assignWorkoutTemplate() async {
    if (_selectedWorkoutTemplateId != null) {
      try {
        await _workoutService.assignWorkoutTemplate(
            widget.member.id, _selectedWorkoutTemplateId!);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workout Template Assigned')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to assign workout template: $error')));
      }
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member.name),
        actions: [
          if(user?.role=="Admin")
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              size: 40,
            ),
            onPressed: _isEditing ? _saveChanges : _toggleEditing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: widget.member.imageUrl != null? CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, progress) => Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                          imageUrl: widget.member.imageUrl!,
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeOutDuration: const Duration(milliseconds: 500),
                        ) : _image == null
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
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  _buildSection(context, 'Personal Information',
                      _buildPersonalInfoTable()),
                  _buildSection(context, 'Membership Details',
                      _buildMembershipDetailsTable()),

                  _buildSection(
                      context, 'Package Details', _buildPackageDetails()),
                  _buildSection(context, 'Diet Assignment',
                      _buildDietAssignmentSection()),
                  _buildSection(context, 'Workout Assignment',
                      _buildWorkoutAssignmentSection()),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentHistoryPage(member: widget.member),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: appLightGreen),
                      child: const Text('View Payment History',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberAttendancePage(
                                memberId: widget.member.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: appLightGreen),
                      child: const Text('View Attendance History',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sectionWidth =
        screenWidth > 600 ? screenWidth / 2 - 32 : screenWidth;

    return Container(
      width: sectionWidth,
      decoration: BoxDecoration(
        border: Border.all(color: appLightGreen, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: appContainerColors,
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 5, offset: Offset(2,5))
          ]
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
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTable() {
    return _buildDetailTable([
      _buildEditableDetailRow(Icons.person, 'Name', _nameController),
      _buildEditableLevelRow(Icons.star, 'User Level'),
      _buildEditableDetailRow(Icons.cake, 'Age', _ageController,
          isNumber: true),
      _buildEditableDetailRow(Icons.wc, 'Gender', _genderController),
      _buildEditableDetailRow(Icons.email, 'Email', _emailController),
      _buildEditableDetailRow(
          Icons.phone, 'Phone Number', _phoneNumberController),
      _buildEditableDetailRow(Icons.home, 'Address', _addressController),
    ]);
  }

  Widget _buildMembershipDetailsTable() {
    if (_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDatePickerRow(Icons.calendar_today, 'Membership Start Date',
              _membershipStartDateController),
          _buildDatePickerRow(Icons.calendar_today, 'Membership End Date',
              _membershipEndDateController),
        ],
      );
    } else {
      return _buildDetailTable([
        _buildDetailRow(Icons.access_time, 'Membership Duration',
            widget.member.getMembershipDuration()),
        _buildDetailRow(Icons.calendar_today, 'Membership Start Date',
            _formatDate(widget.member.membershipStartDate)),
        _buildDetailRow(Icons.calendar_today, 'Membership End Date',
            _formatDate(widget.member.membershipEndDate)),
        SizedBox(height: 30,),
        _buildMembershipProgressBar(),
      ]);
    }
  }

  Widget _buildMembershipProgressBar(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.member.getRemainingDays()} days remaining",
          style: TextStyle(
              fontSize: 20,
              color: appMediumColor,
              fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
        LinearPercentIndicator(
          animation: true,
          animationDuration: 2500,
          animateFromLastPercent: true,
          lineHeight: 11,
          // width: MediaQuery.of(context).size.width/2.5,
          barRadius: Radius.circular(19),
          progressColor: appDarkGreen,
          percent: calculateProgress(widget.member.membershipEndDate.subtract(Duration(days: widget.member.currentPackage!.packageDuration)), widget.member.membershipEndDate),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025,),

        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("From : ", style : TextStyle(fontWeight: FontWeight.w600)),
            Text(_formatDate(widget.member.membershipEndDate.subtract(Duration(days: widget.member.currentPackage!.packageDuration)))),
            SizedBox(width: MediaQuery.of(context).size.width * 0.07,),
            Text("To : ", style : TextStyle(fontWeight: FontWeight.w600)),
            Text(_formatDate(widget.member.membershipEndDate)),
          ],
        )
      ],
    );
  }

  Widget _buildEditableLevelRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: appLightGreen),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style:
          TextStyle(fontWeight: FontWeight.bold, color: appLightGreen),
        ),
        (_isEditing)
            ? Expanded(
                child: DropdownButtonFormField<MembershipLevel>(
                  value: _selectedLevel,
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
                  items: MembershipLevel.values.map((MembershipLevel level) {
                    return DropdownMenuItem<MembershipLevel>(
                      value: level,
                      child: Text(level.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value;
                    });
                  },
                ),
              )
            : Text(widget.member.level.name),
      ],
    );
  }

  Widget _buildDatePickerRow(
      IconData icon, String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: appLightGreen),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: appLightGreen),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context, controller),
              child: IgnorePointer(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
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
                  style:  TextStyle(color: appLightGreen),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
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
        ? Column(
          children: [
            DropdownButtonFormField<Package>(
                value: _selectedPackage,
                hint: const Text('Select Package'),
                onChanged: (Package? newValue) {
                  setState(() {
                    _selectedPackage = newValue!;
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
            )

          ],
        )
        : _buildDetailTable([
            _buildDetailRow(Icons.star, 'Package ID',
                widget.member.currentPackage?.packageID ?? 'N/A'),
            _buildDetailRow(Icons.timer, 'Duration',
                '${widget.member.currentPackage?.packageDuration ?? 'N/A'} days'),
            _buildDetailRow(Icons.label, 'Level',
                widget.member.currentPackage?.level ?? 'N/A'),
            _buildDetailRow(
                Icons.monetization_on,
                'Amount',
                widget.member.currentPackage != null
                    ? '\$${widget.member.currentPackage!.amount.toStringAsFixed(2)}'
                    : 'N/A'),
      _buildDetailRow(Icons.hiking, 'Personal Training',
          widget.member.isPT?"Yes" : "No"),
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
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style:  TextStyle(
                fontWeight: FontWeight.bold, color: appLightGreen),
          ),
          Expanded(
            child: Text(
              value,
              // style:  TextStyle(color: appLightGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableDetailRow(
      IconData icon, String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: appLightGreen),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style:  TextStyle(
                fontWeight: FontWeight.bold, color: appLightGreen),
          ),
          Expanded(
            child: _isEditing
                ? TextField(
                    controller: controller,
                    keyboardType:
                        isNumber ? TextInputType.number : TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: appLightGreen, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: appLightGreen, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: appLightGreen, width: 1.0),
                        ),
                        fillColor: Colors.white10),
                    // style:  TextStyle(color: appLightGreen),
                  )
                : Text(
                    controller.text,
                    // style:  TextStyle(color: appLightGreen),
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
        const SizedBox(height: 16),
        Text(
          'Selected Diet:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appLightGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _dietTemplates
              .firstWhere(
                (template) =>
                    template.templateID == widget.member.dietTemplateID,
                orElse: () => DietTemplate(
                    templateID: '', templateName: 'None Selected', diets: []),
              )
              .templateName,
          style:  TextStyle(color: appLightGreen),
        ),
        if (user?.role=="Admin" || user?.role=="Manager")
        ElevatedButton(
          onPressed: () async {
            if (_selectedDietTemplateId != null) {
              try {
                await _memberService.updateDietTemplateId(
                    widget.member.id, _selectedDietTemplateId!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please select a diet template'),
                backgroundColor: Colors.orange,
              ));
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: appLightGreen),
          child:
              const Text('Assign Diet', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildWorkoutAssignmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Workout Template',
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
          value: _selectedWorkoutTemplateId,
          onChanged: (newValue) {
            setState(() {
              _selectedWorkoutTemplateId = newValue;
            });
          },
          items: _workoutTemplates.map((template) {
            return DropdownMenuItem<String>(
              value: template.id,
              child: Text(template.templateName),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Selected Workout template:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appLightGreen,
          ),
        ),
        const SizedBox(height: 8),
        // if (_isEditing)
        if (user?.role=="Admin" || user?.role=="Manager")
        ElevatedButton(
          onPressed: () async {
            if (_selectedWorkoutTemplateId != null) {
              try {
                await _workoutService.assignWorkoutTemplate(
                    widget.member.id, _selectedWorkoutTemplateId!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Workout assigned successfully'),
                  backgroundColor: Colors.green,
                ));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to assign workout template: $e'),
                  backgroundColor: Colors.red,
                ));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please select a workout template'),
                backgroundColor: Colors.orange,
              ));
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: appLightGreen),
          child: const Text('Assign Workouts',
              style: TextStyle(color: Colors.white)),
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
    if(user?.role=="Trainer"){
      return;
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    // Save the changes to the member details
    try {
      // var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      // var storageRef = FirebaseStorage.instance.ref().child('driver_images/$imageName.jpg');
      // var uploadTask = storageRef.putFile(_image!);
      // var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      // widget.member.imageUrl=downloadUrl;
      // Update the member object with new details
      String imageUrl ="";
      if (_image != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profilePic')
            .child('${_emailController.text}.jpg');

        final UploadTask uploadTask = storageRef.putFile(_image!);
        final TaskSnapshot storageSnapshot = await uploadTask;

        // Get the download URL of the uploaded image
        final String downloadUrl = await storageSnapshot.ref.getDownloadURL();
        imageUrl = downloadUrl;
      }

      print("image url @MemberDetail850 ${imageUrl}");

      widget.member.name = _nameController.text;
      widget.member.level = _selectedLevel ?? widget.member.level;
      widget.member.age = int.parse(_ageController.text);
      widget.member.imageUrl=imageUrl;
      widget.member.gender = _genderController.text;
      widget.member.email = _emailController.text;
      widget.member.phoneNumber = _phoneNumberController.text;
      widget.member.address = _addressController.text;
      widget.member.membershipStartDate =
          DateTime.parse(_membershipStartDateController.text);
      widget.member.membershipEndDate =
          DateTime.parse(_membershipEndDateController.text);

      // Check if package is changed
      bool packageChanged = _selectedPackage != null;
      widget.member.currentPackage =
          _selectedPackage ?? widget.member.currentPackage;

      if (packageChanged) {
        // Show confirmation dialog
        bool confirmPurchaseHistory = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Payment History Addition'),
              content: const Text(
                  'Do you want to add payment history for the new package?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false if not confirmed
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true if confirmed
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        if (confirmPurchaseHistory == true) {
          // Call service to add purchase history
          await _addPurchaseOrderHistory(widget.member.membershipStartDate,
              widget.member.membershipEndDate);
        }
      }

      // Call the service to update member details in the backend
      await _memberService.updateMember(widget.member);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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

  Future<void> _addPurchaseOrderHistory(
      DateTime startDate, DateTime endDate) async {
    try {
      // Create a new purchase order history object
      PurchaseOrder purchaseOrder = PurchaseOrder(
        memberId: widget.member.id,
        gymMemberID: widget.member.gymMemberID,
        packageId: _selectedPackage!.packageID ??
            widget.member.currentPackage!.packageID ??
            "",
        timeOfPO: DateTime.now(),
        amountPaid: _selectedPackage!.amount,
        membershipStartDate: startDate,
        membershipEndDate: endDate,
        purchaseOrderId: '',
      );

      // Call the service to add purchase order history
      await PurchaseOrderService().addPurchaseOrder(purchaseOrder);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
