import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:kumbu_admin/Screens/EventsListPage.dart';

import '../Models/GymEvent.dart';
import '../service/EventService.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventService = GymEventService();
  final _event = GymEvent(
    title: '',
    description: '',
    date: '',
    startTime: '',
    endTime: '',
    location: '',
    host: '',
  );

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _eventService.createEvent(_event);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event created successfully')),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Title', (value) => _event.title = value),
              _buildTextField('Description', (value) => _event.description = value, maxLines: 3),
              _buildTextField('Date', (value) => _event.date = value),
              _buildTextField('Start Time', (value) => _event.startTime = value),
              _buildTextField('End Time', (value) => _event.endTime = value),
              _buildTextField('Location', (value) => _event.location = value),
              _buildTextField('Host', (value) => _event.host = value),
              _buildTextField('Entry Fee', (value) => _event.entryFee = double.tryParse(value)),
              _buildTextField('Reward', (value) => _event.reward = value),
              _buildTextField('Image URL', (value) => _event.imageUrl = value),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: appDarkGreen,
                //   padding: EdgeInsets.symmetric(vertical: 15),
                // ),
                child: Text('Create Event', style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EventsListPage()));
                },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: appDarkGreen,
                //   padding: EdgeInsets.symmetric(vertical: 15),
                // ),
                child: Text('View all Events', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSaved: (value) => onSaved(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
        maxLines: maxLines,
      ),
    );
  }
}
