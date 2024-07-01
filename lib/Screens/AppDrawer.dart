import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: appDarkGreen,
            ),
            child: Text(
              'Kumbu Fitness',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.local_fire_department),
            title: Text('Package Page'),
            onTap: () {
              Navigator.pushNamed(context, '/package');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Requests'),
            onTap: () {
              Navigator.pushNamed(context, '/requestPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.set_meal_sharp),
            title: Text('Diets'),
            onTap: () {
              Navigator.pushNamed(context, '/dietsPage');
            },
          ),
        ],
      ),
    );
  }
}
