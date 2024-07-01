import 'package:flutter/material.dart';

import '../../Common/ThemeData.dart';
import '../../Models/DietTemplate.dart';

class ViewDietTemplatePage extends StatelessWidget {
  final DietTemplate dietTemplate;

  ViewDietTemplatePage({required this.dietTemplate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dietTemplate.templateName),
      ),
      body: ListView.builder(
        itemCount: dietTemplate.diets.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: appLightGreen, width: 1.0), // Border color and width
            ),
            child: ListTile(
              title: Text(dietTemplate.diets[index].period),

              subtitle: Text('Food: ${dietTemplate.diets[index].food}, Quantity: ${dietTemplate.diets[index].quantity}'),
              titleAlignment: ListTileTitleAlignment.center,
            ),
          );

        },
      ),
    );
  }
}
