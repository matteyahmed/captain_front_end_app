import 'package:captain_app_2/FuelSheetForm.dart';
import 'package:captain_app_2/firebase_api.dart';
import 'package:captain_app_2/itemRequest_form.dart';
import 'package:captain_app_2/checklist_form.dart';
import 'package:captain_app_2/fuelSheetScreen.dart';
import 'package:captain_app_2/itemRequest_screen.dart';
import 'package:captain_app_2/leaverequest_form.dart';
import 'package:captain_app_2/providers/token_provider.dart';
import 'package:captain_app_2/providers/userprovider.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

import './profile_screen.dart';
import './tripsheet_screen.dart';
import './tripsheet_form.dart';
import './changeboat.dart';
import './check_list.dart';
import './lottie.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await FirebaseApi().initNotifications();
  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TokenProvider()),
        ChangeNotifierProvider(create: (context) => UserSocketProvider(context)),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ('Arriva'),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.orange[99],

        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/profile': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return ProfileScreen(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        // '/tripSheet': (context) => const TripSheetScreen(),
        '/tripSheet': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return TripSheetScreen(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/tripSheetForm': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return TripSheetForm();
        },
        '/checkList': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return CheckListScreen(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/checkListForm': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return CheckListForm(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/changeboat': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return ChangeBoat(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/fuelSheetScreen': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return FuelSheetScreen(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/itemRequestScreen': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return ItemRequestScreen(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/itemRequestForm': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return ItemRequestForm(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/leaveRequestForm': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;

          return LeaveRequstForm(
            apiUrl: args?['apiUrl'] as String? ??
                '', // Provide a default value if null
            token: args?['token'] as String? ??
                '', // Provide a default value if null
          );
        },
        '/lottie': (context) {
          final Map<String, dynamic>? args = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>?;
          return LottieAnim();
        },
      },
    );
  }
}
