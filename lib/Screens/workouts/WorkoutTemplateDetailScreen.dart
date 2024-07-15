// screens/workout_template_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';

import '../../Models/WorkoutTemplate.dart';
import '../../service/WorkoutTemplateService.dart';

class WorkoutTemplateDetailScreen extends StatefulWidget {
  final WorkoutTemplate? workoutTemplate;
  final VoidCallback onSave;

  WorkoutTemplateDetailScreen({this.workoutTemplate, required this.onSave});

  @override
  _WorkoutTemplateDetailScreenState createState() =>
      _WorkoutTemplateDetailScreenState();
}

class _WorkoutTemplateDetailScreenState
    extends State<WorkoutTemplateDetailScreen> {
  final WorkoutTemplateService _service = WorkoutTemplateService();
  final _formKey = GlobalKey<FormState>();
  late String _templateName;
  late List<Workout> _workouts;

  final Color appLightGreen = Color(0xFF75D8A9);

  @override
  void initState() {
    super.initState();
    _templateName = widget.workoutTemplate?.templateName ?? '';
    _workouts = widget.workoutTemplate?.workouts ?? [];
  }

  void _saveTemplate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTemplate = WorkoutTemplate(
        id: widget.workoutTemplate?.id ?? '',
        templateName: _templateName,
        workouts: _workouts,
      );

      try {
        if (widget.workoutTemplate == null) {
          await _service.createWorkoutTemplate(newTemplate);
        } else {
          await _service.updateWorkoutTemplate(newTemplate);
        }
        widget.onSave();
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save template: $error')),
        );
      }
    }
  }

  void _addWorkout() {
    setState(() {
      _workouts.add(Workout(
        workoutName: '',
        referenceURL: '',
        instructions: '',
      ));
    });
  }

  void _removeWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutTemplate == null
            ? 'Create Workout Template'
            : 'Edit Workout Template'),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: appLightGreen,),
            onPressed: _saveTemplate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _templateName,
                decoration: InputDecoration(labelText: 'Template Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a template name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _templateName = value!;
                },
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    Workout workout = _workouts[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: appLightGreen, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: workout.workoutName,
                              decoration: InputDecoration(labelText: 'Workout Name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a workout name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                workout.workoutName = value!;
                              },
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              initialValue: workout.referenceURL,
                              decoration: InputDecoration(labelText: 'Reference URL'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a reference URL';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                workout.referenceURL = value!;
                              },
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              initialValue: workout.instructions,
                              decoration: InputDecoration(labelText: 'Instructions'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter instructions';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                workout.instructions = value!;
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removeWorkout(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(

                onPressed: _addWorkout,

                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: appDarkGreen
                  ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('Add Workout', style: TextStyle(color: Colors.white),)),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
