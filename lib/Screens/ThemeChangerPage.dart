import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:kumbu_admin/Screens/MembersListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart'; // Import the package

class ColorPickerPage extends StatefulWidget {
  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color appGrey = Color(0xffb3b3b3);
  Color appDarkGreen = Color(0xff9f0209);
  Color appLightGreen = Color(0xff775e5f);
  Color appMediumColor = Color(0xffc15151);
  Color appBackgroundColor = Color(0xffffffff);

  @override
  void initState() {
    super.initState();
    _loadSavedColors();
  }

  Future<void> _loadSavedColors() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      appGrey = Color(prefs.getInt('appGrey') ?? 0xffb3b3b3);
      appDarkGreen = Color(prefs.getInt('appDarkGreen') ?? 0xff9f0209);
      appLightGreen = Color(prefs.getInt('appLightGreen') ?? 0xff775e5f);
      appMediumColor = Color(prefs.getInt('appMediumColor') ?? 0xffc15151);
      appBackgroundColor = Color(prefs.getInt('appBackgroundColor') ?? 0xffffffff);

    });
  }

  Future<void> _saveColor(String key, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, color.value);
    print("wlkdf");
    print("$key - ${color.value}");
  }

  void _pickColor(BuildContext context, String colorKey, Color currentColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  switch (colorKey) {
                    case 'appGrey':
                      appGrey = color;
                      break;
                    case 'appDarkGreen':
                      appDarkGreen = color;
                      break;
                    case 'appLightGreen':
                      appLightGreen = color;
                      break;
                    case 'appMediumColor':
                      appMediumColor = color;
                      break;
                    case 'appBackgroundColor':
                      appBackgroundColor = color;
                      break;

                  }
                });
                _saveColor(colorKey, color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Save & Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                Restart.restartApp();
              },
            ),
          ],
        );
      },
    );
  }

  void _restartApp() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MembersListPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Picker'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Background Color'),
            trailing: GestureDetector(
              onTap: () => _pickColor(context, 'appBackgroundColor', appBackgroundColor),
              child: CircleAvatar(
                backgroundColor: appBackgroundColor,
              ),
            ),
          ),
          ListTile(
            title: Text('Primary Color'),
            trailing: GestureDetector(
              onTap: () => _pickColor(context, 'appDarkGreen', appDarkGreen),
              child: CircleAvatar(
                backgroundColor: appDarkGreen,
              ),
            ),
          ),
          ListTile(
            title: Text('Secondary Color'),
            trailing: GestureDetector(
              onTap: () => _pickColor(context, 'appLightGreen', appLightGreen),
              child: CircleAvatar(
                backgroundColor: appLightGreen,
              ),
            ),
          ),
          ListTile(
            title: Text('3rd Color'),
            trailing: GestureDetector(
              onTap: () => _pickColor(context, 'appMediumColor', appMediumColor),
              child: CircleAvatar(
                backgroundColor: appMediumColor,
              ),
            ),
          ),
          ListTile(
            title: Text('Liners color'),
            trailing: GestureDetector(
              onTap: () => _pickColor(context, 'appGrey', appGrey),
              child: CircleAvatar(
                backgroundColor: appGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
