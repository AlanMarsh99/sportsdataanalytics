import 'package:flutter/material.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/ui/theme.dart';

import 'package:intl/intl.dart';

class Globals {
  static String baseUrl = 'http://127.0.0.1:8000/api/v1';

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

  static final Map models = {
    UserApp: (data) => UserApp.fromMap(data),
  };

  static String toLocalDate(DateTime d) {
    String date = DateFormat('dd/MM/yyyy HH:mm').format(d);
    return date;
  }

  static const kHintTextStyle = TextStyle(
    color: Colors.white70,
    fontSize: 16,
    fontFamily: 'OpenSans',
  );

  static const kHintTextStyle2 = TextStyle(
    fontSize: 16,
    color: Colors.white70,
    fontFamily: 'OpenSans',
  );

  static const kLabelStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'OpenSans',
      fontSize: 16);

  static final kBoxDecorationStyle = BoxDecoration(
    color: primary,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
}
