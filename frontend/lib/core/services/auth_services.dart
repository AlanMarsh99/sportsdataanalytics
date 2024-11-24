import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/core/providers/user_provider.dart';
import 'package:frontend/core/services/firestore_service.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/widgets/dialogs/warning_error_dialog.dart';
import 'package:provider/provider.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthService extends ChangeNotifier {
  AuthService() {
    _auth.authStateChanges().listen((newUser) async {
      if (newUser == null) {
        _status = Status.Unauthenticated;
      } else {
        _status = Status.Authenticated;
        user = newUser;

        userApp = await Document<UserApp>(
          path: 'users/${user!.uid}',
        ).getData();
      }
      notifyListeners();
    }, onError: (e) {
      print('AuthService - error: $e');
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Status _status = Status.Uninitialized;
  User? user;
  UserApp? userApp;
  Status get status => _status;

  /// Attempts to sign in Firebase Auth
  Future<bool> signIn(String email, String password) async {
    _status = Status.Authenticating;
    notifyListeners();
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      userApp = await Document<UserApp>(
        path: 'users/${userCredential.user!.uid}',
      ).getData();

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      if (e.code == Globals.USER_NOT_FOUND) {
        print('No user found for that email.');
      } else if (e.code == Globals.WRONG_PASSWORD) {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future<void> signUp(BuildContext context, String email, String username,
      String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Create user in Firebase Authentication with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the user ID (UID)
      String uid = userCredential.user!.uid;

      UserApp newUser = UserApp(
        id: uid,
        username: username,
        email: email,
        totalPoints: 0,
        seasonPoints: 0,
        level: 1,
        avatar: 'default',
        numPredictions: 0,
        leaguesFinished: 0,
        leaguesWon: 0,
      );

      // Store the user's data in Firestore under a 'users' collection with the UID as the document ID
      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      print("User signed up and data added to Firestore successfully!");
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      if (e.code == Globals.WEAK_PASSWORD) {
        await showDialog(
          context: context,
          builder: (context) {
            return WarningDialog(
              error: true,
              message:
                  'Your password must be at least 8 characters long and include at least one letter and one number.',
            );
          },
        );
        print('The password provided is too weak.');
      } else if (e.code == Globals.EMAIL_ALREADY_IN_USE) {
        await showDialog(
          context: context,
          builder: (context) {
            return WarningDialog(
              error: true,
              message: 'An account already exists for that email.',
            );
          },
        );
        print('An account already exists for that email.');
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return WarningDialog(
              error: true,
              message: 'An unexpected error occurred: ${e.code}.',
            );
          },
        );
        print(e.message);
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return WarningDialog(
            error: true,
            message: 'An unexpected error occurred: ${e.toString()}.',
          );
        },
      );
      print(e.toString());
    }
  }

  /// Attempts to sign out from Firebase Auth
  Future<void> signOut() async {
    await _auth.signOut();
    _status = Status.Uninitialized;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  /// Attemps to update the password, if user last login is too old,
  /// reauthentication will be needed
  Future<bool> updatePassword(
      BuildContext context, String currentPassword, String newPassword) async {
    bool passwordChanged = false;

    var credential = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);
    if (credential != null) {
      if (await reauthenticate(credential)) {
        await user!.updatePassword(newPassword);
        await showDialog(
          context: context,
          builder: (context) {
            return WarningDialog(
              error: false,
              message: 'Password updated successfully.',
            );
          },
        );
        passwordChanged = true;
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return WarningDialog(
              error: true,
              message: 'Incorrect current password.',
            );
          },
        );
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return WarningDialog(
            error: true,
            message: 'Password authentication failed.',
          );
        },
      );
    }
    return passwordChanged;
  }

  Future<bool> reauthenticate(AuthCredential credential) async {
    try {
      await _auth.currentUser!.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case Globals.USER_MISMATCH:
          print('Incorrect Credentials');
          break;
        case Globals.USER_NOT_FOUND:
          print('Incorrect Credentials');

          break;
        case Globals.INVALID_CREDENTIAL:
          print('Incorrect Credentials');

          break;
        case Globals.INVALID_EMAIL:
          print('Incorrect Credentials');

          break;
        case Globals.WRONG_PASSWORD:
          print('Incorrect Credentials');

          break;
      }
      return false;
    }
  }
}
