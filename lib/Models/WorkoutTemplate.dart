// models/workout_template.dart
class Workout {
  String workoutName;
   String referenceURL;
   String instructions;

  Workout({
    required this.workoutName,
    required this.referenceURL,
    required this.instructions,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      workoutName: json['workoutName'],
      referenceURL: json['referenceURL'],
      instructions: json['instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutName': workoutName,
      'referenceURL': referenceURL,
      'instructions': instructions,
    };
  }
}

class WorkoutTemplate {
  final String id;
  final String templateName;
  final List<Workout> workouts;

  WorkoutTemplate({
    required this.id,
    required this.templateName,
    required this.workouts,
  });

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) {
    var workoutsFromJson = json['workouts'] as List;
    List<Workout> workoutList =
    workoutsFromJson.map((i) => Workout.fromJson(i)).toList();

    return WorkoutTemplate(
      id: json['_id'],
      templateName: json['templateName'],
      workouts: workoutList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'templateName': templateName,
      'workouts': workouts.map((e) => e.toJson()).toList(),
    };
  }
}
