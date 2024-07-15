// screens/workout_template_list_screen.dart
import 'package:flutter/material.dart';

import '../../Common/ThemeData.dart';
import '../../Models/WorkoutTemplate.dart';
import '../../service/WorkoutTemplateService.dart';
import 'WorkoutTemplateDetailScreen.dart';

class WorkoutTemplateListScreen extends StatefulWidget {
  @override
  _WorkoutTemplateListScreenState createState() =>
      _WorkoutTemplateListScreenState();
}

class _WorkoutTemplateListScreenState extends State<WorkoutTemplateListScreen> {
  final WorkoutTemplateService _service = WorkoutTemplateService();
  late Future<List<WorkoutTemplate>> _workoutTemplates;

  @override
  void initState() {
    super.initState();
    _workoutTemplates = _service.fetchWorkoutTemplates();
  }

  void _refreshList() {
    setState(() {
      _workoutTemplates = _service.fetchWorkoutTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Templates'),
      ),
      body: FutureBuilder<List<WorkoutTemplate>>(
        future: _workoutTemplates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No workout templates found.'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 3.5,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: appLightGreen, width: 1.0), // Border color and width
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutTemplateDetailScreen(workoutTemplate: snapshot.data![index], onSave: _refreshList),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          snapshot.data![index].templateName,
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );

              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutTemplateDetailScreen(
                onSave: _refreshList,
              ),
            ),
          );
        },
      ),
    );
  }
}
