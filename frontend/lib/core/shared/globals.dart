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

  static final Map<String, String> teamLogos = {
    'Alpine F1 Team': 'assets/teams/logos/alpine-logo.png',
    'Aston Martin': 'assets/teams/logos/aston-martin-logo.png',
    'Ferrari': 'assets/teams/logos/ferrari-logo.png',
    'Haas F1 Team': 'assets/teams/logos/haas-logo.png',
    'McLaren': 'assets/teams/logos/mclaren-logo.png',
    'Mercedes': 'assets/teams/logos/mercedes-logo.png',
    'RB F1 Team': 'assets/teams/logos/rb-logo.png',
    'Red Bull': 'assets/teams/logos/red-bull-logo.png',
    'Sauber': 'assets/teams/logos/sauber-logo.png',
    'Williams': 'assets/teams/logos/williams-logo.png',
  };

  static final Map<String, String> teamBadges = {
    'Red Bull': 'assets/teams/badges/red-bull-badge.png',
    'Mercedes': 'assets/teams/badges/mercedes-badge.png',
    'Ferrari': 'assets/teams/badges/ferrari-badge.png',
    'McLaren': 'assets/teams/badges/mclaren-badge.png',
    'Aston Martin': 'assets/teams/badges/aston-martin-badge.png',
    'Alpine F1 Team': 'assets/teams/badges/alpine-badge.png',
    'Williams': 'assets/teams/badges/williams-badge.png',
    'Haas F1 Team': 'assets/teams/badges/haas-badge.png',
    'Sauber': 'assets/teams/badges/sauber-badge.png',
    'RB F1 Team': 'assets/teams/badges/rb-badge.png',
  };

  static const Map<String, String> teamNameMapping = {
    'Red Bull Racing': 'Red Bull',
    'Scuderia Ferrari': 'Ferrari',
    'Mercedes AMG Petronas': 'Mercedes',
    'McLaren F1 Team': 'McLaren',
    'Aston Martin': 'Aston Martin',
    'Alpine F1 Team': 'Alpine F1 Team',
    'Williams Racing': 'Williams',
    'Haas F1 Team': 'Haas F1 Team',
    'Alfa Romeo': 'Sauber',
    'AlphaTauri': 'RB F1 Team',
  };

  static const Map<String, String> driverImages = {
    'Hamilton': 'assets/drivers/hamilton.webp',
    'Verstappen': 'assets/drivers/max-verstappen.webp',
    'Russell': 'assets/drivers/russell.webp',
    'Pérez': 'assets/drivers/perez.webp',
    'Leclerc': 'assets/drivers/leclerc.webp',
    'Sainz': 'assets/drivers/sainz.webp',
    'Norris': 'assets/drivers/norris.webp',
    'Piastri': 'assets/drivers/piastri.webp',
    'Alonso': 'assets/drivers/alonso.webp',
    'Ocon': 'assets/drivers/ocon.webp',
    'Bottas': 'assets/drivers/bottas.webp',
    'Zhou': 'assets/drivers/zhou.webp',
    'Sargeant': 'assets/drivers/sargeant.webp',
    'Albon': 'assets/drivers/albon.webp',
    'Ricciardo': 'assets/drivers/ricciardo.webp',
    'Tsunoda': 'assets/drivers/tsunoda.webp',
    'Stroll': 'assets/drivers/stroll.webp',
    'Gasly': 'assets/drivers/gasly.webp',
    'Hülkenberg': 'assets/drivers/hulkenberg.webp',
    'Magnussen': 'assets/drivers/magnussen.webp',
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
