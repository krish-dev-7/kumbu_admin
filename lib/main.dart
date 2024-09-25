import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:kumbu_admin/Models/User.dart';
import 'package:kumbu_admin/Screens/AttendancePage.dart';
import 'package:kumbu_admin/Screens/GlobalPaymentHistory.dart';
import 'package:kumbu_admin/Screens/PackageRequestPage.dart';
import 'package:kumbu_admin/Screens/ThemeChangerPage.dart';
import 'package:kumbu_admin/Screens/TrainersListPage.dart';
import 'package:kumbu_admin/Screens/diets/DietsTemplatePage.dart';
import 'package:kumbu_admin/service/UserService.dart';
import 'package:kumbu_admin/service/auth/sign_in.dart';

import 'Common/config.dart';
import 'Models/Member.dart';
import 'Screens/MembersListPage.dart';
import 'Screens/PackagePage.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/createEventPage.dart';
import 'Screens/workouts/WokoutTemplateListScreen.dart';
import 'firebase_options.dart';
import 'Screens/MembershipRequestPage.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Kumbu Admin App',
    theme: appTheme,
    debugShowCheckedModeBanner: false,
    // home: MembersListPage(),
    initialRoute: '/',
    routes: {
      '/': (context) => AuthenticationWrapper(),
      '/package': (context) => PackagePage(),
      '/profile': (context) => ProfilePage(),
      '/SubscriptionRequestPage': (context) => QuotationPage(),
      '/dietsPage': (context) => DietTemplatesPage(),
      '/workoutPage': (context) => WorkoutTemplateListScreen(),
      '/incomeHistory': (context) => GlobalPaymentHistoryPage(),
      '/AttendancePage': (context) => AttendancePage(),
      '/MembershipRequestPage': (context) => MembershipRequestsPage(),
      '/ThemeChangePage': (context) => ColorPickerPage(),
      '/TrainersListPage': (context)=>UserListPage(),
      '/AddEventsPage' : (context)=> CreateEventPage()
    },
  ));
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  void authorize(email) async{
    user = await UserService().getUserByEmail(email);
    if(user==null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not authorized')),
      );
      FirebaseAuth.instance.signOut();  // Sign out the user
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            authorize(snapshot.data?.email);
            return MembersListPage();
          } else {
            // User is not signed in, navigate to SignInPage
            return const SignInScreen();
          }
        }
      },
    );
  }
}
