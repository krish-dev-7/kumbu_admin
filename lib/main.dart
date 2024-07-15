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

void main() {

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
      '/incomeHistory': (context) => GlobalPaymentHistoryPage(),
      '/AttendancePage': (context) => AttendancePage()
    },
  ));
}
