import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/providers/user_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/ui/screens/navigation/navigation_screen.dart';
import 'package:frontend/ui/screens/splash_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    /*Phoenix(
      child: */MultiProvider(providers: [
        ChangeNotifierProvider.value(value: AuthService()),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
        //ChangeNotifierProvider(create: (_) => UserProvider()),
      ], child: const MyApp()),
   // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: NavigationScreen(),
      //SplashScreen(),
    );
  }
}
