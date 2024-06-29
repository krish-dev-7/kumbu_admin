import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import '../Models/Package.dart';
import '../service/PackageService.dart';
import 'PackageListPage.dart';

class PackagePage extends StatefulWidget {
  @override
  _PackagePageState createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  final _formKey = GlobalKey<FormState>();
  final _packageIDController = TextEditingController();
  final _packageDurationController = TextEditingController();
  final _levelController = TextEditingController();
  final _amountController = TextEditingController();
  final PackageService _packageService = PackageService();

  @override
  void dispose() {
    _packageIDController.dispose();
    _packageDurationController.dispose();
    _levelController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newPackage = Package(
        packageID: _packageIDController.text,
        packageDuration: int.parse(_packageDurationController.text),
        level: _levelController.text,
        amount: double.parse(_amountController.text),
      );

      try {
        await _packageService.addPackage(newPackage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Package added successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PackageListPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding package: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Package'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _packageIDController,
                decoration: InputDecoration(
                  labelText: 'Package ID',
                  // labelStyle: TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Package ID';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _packageDurationController,
                decoration: InputDecoration(
                  labelText: 'Package Duration (days)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Package Duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _levelController,
                decoration: InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Level';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Package', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(appDarkGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PackageListPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(appDarkGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                    ),
                  ),
                ),
                child: Text('View Packages', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
