/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/providers/user_provider.dart';
import 'package:frontend/ui/screens/navigation/navigation_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder(
      future: _checkUserAndFetchData(userProvider),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return NavigationScreen();
        }
      },
    );
  }

  Future<bool> _checkUserAndFetchData(UserProvider userProvider) async {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser != null) {
      await userProvider.fetchUserData(authUser.uid);
      return true;
    } else {
      return false;
    }
  }
}*/
