import 'package:flutter/material.dart';
import 'package:frontend/ui/theme.dart';


class Globals {

  // Firebase Auth Exceptions
  static const String SUCCESS = 'success';
  static const String WEAK_PASSWORD = 'weak-password';
  static const String EMAIL_ALREADY_IN_USE = 'email-already-in-use';
  static const String UNCLASSIFIED_ERROR = 'unclassified-error';
  static const String USER_MISMATCH = 'user-mismatch';
  static const String USER_NOT_FOUND = 'user-not-found';
  static const String INVALID_CREDENTIAL = 'invalid-credential';
  static const String INVALID_EMAIL = 'invalid-email';
  static const String WRONG_PASSWORD = 'wrong-password';
  static const String REQUIRES_RECENT_LOGIN = 'requires-recent-login';


  static final kHintTextStyle = TextStyle(
    color: Colors.white70,
    fontSize: 16,
    fontFamily: 'OpenSans',
  );

  static final kHintTextStyle2 = TextStyle(
    fontSize: 16,
    color: Colors.white70,
    fontFamily: 'OpenSans',
  );

  static final kLabelStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'OpenSans',
      fontSize: 16);

  static final kBoxDecorationStyle = BoxDecoration(
    color: primary,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
}
