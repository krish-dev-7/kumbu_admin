import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
import 'package:kumbu_admin/Screens/AttendancePage.dart';
import 'package:kumbu_admin/Screens/GlobalPaymentHistory.dart';
import 'package:kumbu_admin/Screens/RequestPage.dart';
import 'package:kumbu_admin/Screens/diets/DietsTemplatePage.dart';

import 'Models/Member.dart';
import 'Screens/MembersListPage.dart';
import 'Screens/PackagePage.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/workouts/WokoutTemplateListScreen.dart';
import 'firebase_options.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: appTheme,
    debugShowCheckedModeBanner: false,
    home: MembersListPage(),
    initialRoute: '/',
    routes: {
      '/package': (context) => PackagePage(),
      '/profile': (context) => ProfilePage(),
      '/requestPage': (context) => QuotationPage(),
      '/dietsPage': (context) => DietTemplatesPage(),
      '/workoutPage': (context) => WorkoutTemplateListScreen(),
      '/incomeHistory': (context) => GlobalPaymentHistoryPage(),
      '/AttendancePage': (context) => AttendancePage()
    },
  ));
}
