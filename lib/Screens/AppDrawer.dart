import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';

import '../Common/config.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    ) ?? false; // Default to false if dialog is dismissed
  }
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kumbu Fitness',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${user?.name} - ${user?.role}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),),
                ElevatedButton(
                  onPressed: () async {
                    bool confirmLogout = await _showLogoutConfirmationDialog(context);
                    if (confirmLogout) {
                      await _auth.signOut();
                      // Optionally, navigate to the login page or perform other actions
                      Navigator.of(context).pushReplacementNamed('/'); // Adjust as needed
                    }
                  },
                  child: Text('Logout'),
                )
              ],
            )
              ],
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text('Profile'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/profile');
          //   },
          // ),
          // if(user?.role=="Admin")
          ListTile(
            leading: Icon(Icons.local_fire_department),
            title: Text('Package Page'),
            onTap: () {
              Navigator.pushNamed(context, '/package');
            },
          ),
          if(user?.role=="Admin")
          ListTile(
            leading: Icon(Icons.water_drop_rounded),
            title: Text('Subscription Requests'),
            onTap: () {
              Navigator.pushNamed(context, '/SubscriptionRequestPage');
            },
          ),
          if(user?.role=="Admin")
          ListTile(
            leading: Icon(Icons.currency_rupee),
            title: Text('Income Histories'),
            onTap: () {
              Navigator.pushNamed(context, '/incomeHistory');
            },
          ),
          if(user?.role=="Admin")
          ListTile(
            leading: Icon(Icons.set_meal_sharp),
            title: Text('Diets'),
            onTap: () {
              Navigator.pushNamed(context, '/dietsPage');
            },
          ),
          if(user?.role=="Admin")
          ListTile(
            leading: Icon(Icons.crisis_alert),
            title: Text('Workouts'),
            onTap: () {
              Navigator.pushNamed(context, '/workoutPage');
            },
          ),
          if(user?.role=="Admin")
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Entries'),
            onTap: () {
              Navigator.pushNamed(context, '/AttendancePage');
            },
          ),
          if(user?.role=="Admin")
          ListTile(
            leading: Icon(Icons.double_arrow_sharp),
            title: Text('Membership requests'),
            onTap: () {
              Navigator.pushNamed(context, '/MembershipRequestPage');
            },
          ),
          if(user?.role=="Admin")
            ListTile(
              leading: Icon(Icons.double_arrow_sharp),
              title: Text('Trainers Page'),
              onTap: () {
                Navigator.pushNamed(context, '/TrainersListPage');
              },
            ),
          if(user?.role=="Admin")
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Events Page'),
              onTap: () {
                Navigator.pushNamed(context, '/AddEventsPage');
              },
            ),

          //For Next Update

          // ListTile(
          //   leading: Icon(Icons.color_lens_rounded),
          //   title: Text('App Theme'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/ThemeChangePage');
          //   },
          // ),

        ],
      ),
    );
  }
}
