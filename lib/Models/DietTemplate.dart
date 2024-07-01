

import 'Diet.dart';

class DietTemplate {
  final String templateID;
  final String templateName;
  final List<Diet> diets;

  DietTemplate({
    required this.templateID,
    required this.templateName,
    required this.diets,
  });

  factory DietTemplate.fromJson(Map<String, dynamic> json) {
    return DietTemplate(
      templateID: json['_id'],
      templateName: json['templateName'],
      diets: List<Diet>.from(json['diets'].map((diet) => Diet.fromJson(diet))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templateID': templateID,
      'templateName': templateName,
      'diets': diets.map((diet) => diet.toJson()).toList(),
    };
  }
}
