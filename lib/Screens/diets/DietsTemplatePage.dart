import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';

import '../../Models/DietTemplate.dart';
import '../../service/DietTemplateService.dart';
import 'AddDietTemplate.dart';
import 'ViewDietTemplatePage.dart';

class DietTemplatesPage extends StatefulWidget {
  @override
  _DietTemplatesPageState createState() => _DietTemplatesPageState();
}

class _DietTemplatesPageState extends State<DietTemplatesPage> {
  final DietTemplateService _dietTemplateService = DietTemplateService();
  late Future<List<DietTemplate>> _futureDietTemplates;

  @override
  void initState() {
    super.initState();
    _futureDietTemplates = _dietTemplateService.fetchDietTemplates();
  }

  void _deleteDietTemplate(String dietTemplateId) async {
    try {
      await _dietTemplateService.deleteDietTemplate(dietTemplateId);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DietTemplatesPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete diet template: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Templates'),
      ),
      body: FutureBuilder<List<DietTemplate>>(
        future: _futureDietTemplates,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DietTemplate> dietTemplates = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 3.5,
              ),
              itemCount: dietTemplates.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: appLightGreen, width: 1.0),
                  ),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        dietTemplates[index].templateName,
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDietTemplate(dietTemplates[index].templateID),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewDietTemplatePage(dietTemplate: dietTemplates[index]),
                        ),
                      );
                    },
                  ),
                );

              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load diet templates: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDietTemplatePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
