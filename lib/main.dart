import 'package:flutter/material.dart';
import 'login_screen.dart';

import './profile_screen.dart';
import './tripsheet_screen.dart';
import './tripsheet_form.dart';
import './changeboat.dart';

void main() {
  runApp(const MyApp());
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
        scaffoldBackgroundColor: Colors.blueGrey[99],
        // scaffoldBackgroundColor: Colors.blueGrey[99],
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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

          return TripSheetForm(
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
      },
    );
  }
}
