import 'package:flutter/material.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/core/models/avatar.dart';

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
    Avatar: (data) => Avatar.fromMap(data),
  };

  static int nextLevelPoints(int level) {
    switch (level) {
      case 1:
        return 30;
      case 2:
        return 94;
      case 3:
        return 195;
      case 4:
        return 333;
      case 5:
        return 509;
      case 6:
        return 724;
      case 7:
        return 979;
      case 8:
        return 1275;
      case 9:
        return 1611;
      case 10:
        return 1989;
      case 11:
        return 2408;
      case 12:
        return 2870;
      case 13:
        return 3374;
      case 14:
        return 3921;
      case 15:
        return 4511;
      case 16:
        return 5144;
      case 17:
        return 5821;
      case 18:
        return 6541;
      case 19:
        return 7307;
      case 20:
        return 8117;
      default:
        return 0;
    }
  }

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


  static final Map<String, Color> teamColors = {
    'Alpine F1 Team': Color.fromARGB(255, 0, 208, 255),
    'Aston Martin': const Color(0xFF006F62),
    'Ferrari': const Color(0xFFDC0000),
    'Haas F1 Team': const Color(0xFFFFFFFF),
    'McLaren': const Color(0xFFFF8700),
    'Mercedes': const Color(0xFF00D2BE),
    'RB F1 Team': const Color.fromARGB(255, 57, 85, 247),
    'Red Bull': const Color(0xFF1E41FF),
    'Sauber': Color.fromARGB(255, 136, 0, 0),
    'Williams': Color.fromARGB(255, 14, 104, 222),
  };

  static final Map<String, String> driverTeamMapping = {
    'Lewis Hamilton': 'Mercedes',
    'Max Verstappen': 'Red Bull',
    'Charles Leclerc': 'Ferrari',
    'Sergio Pérez': 'Red Bull',
    'Lando Norris': 'McLaren',
    'Carlos Sainz': 'Ferrari',
    'George Russell': 'Mercedes',
    'Pierre Gasly': 'Alpine F1 Team',
    'Nico Hülkenberg': 'Haas F1 Team',
    'Esteban Ocon': 'Alpine F1 Team',
    'Fernando Alonso': 'Aston Martin',
    'Oscar Piastri': 'McLaren',
    'Valtteri Bottas': 'Sauber',
    'Guanyu Zhou': 'Sauber',
    'Logan Sargeant': 'Williams',
    'Alexander Albon': 'Williams',
    'Daniel Ricciardo': 'Haas F1 Team',
    'Yuki Tsunoda': 'RB F1 Team',
    'Nicholas Latifi': 'Williams',
    'Kevin Magnussen': 'Haas F1 Team',
    'Jack Doohan': 'Alpine F1 Team',
    'Oliver Bearman': 'Haas F1 Team',
    'Franco Colapinto': 'Williams',
    'Liam Lawson': 'RB F1 Team',
    'Lance Stroll': 'Aston Martin'
  };

  static final Map<String, Color> driverColors = {
    for (var entry in driverTeamMapping.entries)
      entry.key: teamColors[entry.value] ?? Colors.grey,
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

  static const Map<String, String> countryFlags = {
    "Argentina": "assets/flags/argentina.png",
    "Australia": "assets/flags/australia.png",
    "Austria": "assets/flags/austria.png",
    "Azerbaijan": "assets/flags/azerbaijan.png",
    "Bahrain": "assets/flags/bahrain.png",
    "Belgium": "assets/flags/belgium.png",
    "Brazil": "assets/flags/brazil.png",
    "Canada": "assets/flags/canada.png",
    "China": "assets/flags/china.png",
    "France": "assets/flags/france.png",
    "Germany": "assets/flags/germany.png",
    "Hungary": "assets/flags/hungary.png",
    "India": "assets/flags/india.png",
    "Italy": "assets/flags/italy.png",
    "Japan": "assets/flags/japan.png",
    "Korea": "assets/flags/south-korea.png",
    "Malaysia": "assets/flags/malaysia.png",
    "Mexico": "assets/flags/mexico.png",
    "Monaco": "assets/flags/monaco.png",
    "Morocco": "assets/flags/morocco.png",
    "Netherlands": "assets/flags/netherlands.png",
    "Portugal": "assets/flags/portugal.png",
    "Qatar": "assets/flags/qatar.png",
    "Russia": "assets/flags/russia.png",
    "Saudi Arabia": "assets/flags/saudi-arabia.png",
    "Singapore": "assets/flags/singapore.png",
    "South Africa": "assets/flags/south-africa.png",
    "Spain": "assets/flags/spain.png",
    "Sweden": "assets/flags/sweden.png",
    "Switzerland": "assets/flags/switzerland.png",
    "Turkey": "assets/flags/turkey.png",
    "UAE": "assets/flags/united-arab-emirates.png",
    "UK": "assets/flags/united-kingdom.png",
    "USA": "assets/flags/united-states.png",
    "United States": "assets/flags/united-states.png",
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
