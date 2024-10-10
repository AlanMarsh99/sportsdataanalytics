import 'package:flutter/material.dart';
import 'package:frontend/ui/screens/drivers_screen.dart';
import 'package:frontend/ui/screens/login_screen.dart';
import 'package:frontend/ui/theme.dart';

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
      theme: theme,
      home: LoginScreen()
      //DriversScreen(),
    );
  }
}