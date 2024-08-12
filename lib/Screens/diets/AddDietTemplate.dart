import 'package:flutter/material.dart';
import 'package:kumbu_admin/Screens/diets/DietsTemplatePage.dart';

import '../../Common/ThemeData.dart';
import '../../Models/Diet.dart';
import '../../Models/DietTemplate.dart';
import '../../service/DietTemplateService.dart';

class AddDietTemplatePage extends StatefulWidget {
  @override
  _AddDietTemplatePageState createState() => _AddDietTemplatePageState();
}

class _AddDietTemplatePageState extends State<AddDietTemplatePage> {
  final TextEditingController _templateNameController = TextEditingController();
  final List<Diet> _diets = [];
  final DietTemplateService _dietTemplateService = DietTemplateService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Diet Template'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _templateNameController,
              decoration: InputDecoration(labelText: 'Template Name', border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: appLightGreen, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appLightGreen, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white10,),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddDietDialog(context),
              child: Text('Add Diet Item', style: TextStyle(color: appLightGreen),),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1, // Number of columns in the grid
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 4// Spacing between rows
                ),
                itemCount: _diets.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for the card
                      side: BorderSide(color: Colors.grey[300]!, width: 1.0), // Border color and width
                    ),
                    child: ListTile(
                      title: Text(_diets[index].period),
                      subtitle: Text('${_diets[index].food}, Quantity: ${_diets[index].quantity}'),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(appDarkGreen),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                  ),
                ),
              ),
              onPressed: _saveDietTemplate,
              child: Text('Save Template', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDietDialog(BuildContext context) {
    final TextEditingController _foodController = TextEditingController();
    final TextEditingController _periodController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Diet Item'),
          backgroundColor: appContainerColors,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _periodController,
                decoration: InputDecoration(
                    labelText: 'Period',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white10,),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _foodController,
                decoration: InputDecoration(
                  labelText: 'Food',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: appLightGreen, width: 2.0),
                ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white10,),
              ),
              SizedBox(height: 10,),

              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity', border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: appLightGreen, width: 2.0),
                ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: appLightGreen, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white10,),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _diets.add(Diet(
                    dietID: DateTime.now().toString(),
                    food: _foodController.text,
                    period: _periodController.text,
                    quantity: _quantityController.text,
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveDietTemplate() {
    final String templateName = _templateNameController.text;

    if (templateName.isEmpty || _diets.isEmpty) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a template name and at least one diet item.')),
      );
      return;
    }

    final DietTemplate newTemplate = DietTemplate(
      templateID: DateTime.now().toString(),
      templateName: templateName,
      diets: _diets,
    );

    _dietTemplateService.addDietTemplate(newTemplate).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Diet template saved succesfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DietTemplatesPage()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save diet template: $error')),
      );
    });
  }
}
