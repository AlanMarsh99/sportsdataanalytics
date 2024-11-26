import 'package:cloud_firestore/cloud_firestore.dart';

class Prediction {
  String? id;
  String userId;
  int year;
  int round;
  String? winnerId;
  String? winnerName;
  List<String>? podiumIds;
  List<String>? podiumNames;
  String? fastestLapId;
  String? fastestLapName;
  Timestamp? timestamp;
  int? points;
  String? raceCountry;

  Prediction({
    this.id,
    required this.userId,
    required this.year,
    required this.round,
    required this.raceCountry,
    this.winnerId,
    this.winnerName,
    this.podiumIds,
    this.podiumNames,
    this.fastestLapId,
    this.fastestLapName,
    this.timestamp,
    this.points,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'year': year,
      'round': round,
      'country': raceCountry,
      'winnerId': winnerId,
      'winnerName': winnerName,
      'podiumIds': podiumIds,
      'podiumNames': podiumNames,
      'fastestLapId': fastestLapId,
      'fastestLapName': fastestLapName,
      'timestamp': timestamp,
      'points': points
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
        id: map['id'],
        userId: map['userId'],
        year: map['year'],
        round: map['round'],
        raceCountry: map['country'],
        winnerId: map['winnerId'],
        winnerName: map['winnerName'],
        podiumIds: List<String>.from(map['podiumIds']),
        podiumNames: List<String>.from(map['podiumNames']),
        fastestLapId: map['fastestLapId'],
        fastestLapName: map['fastestLapName'],
        timestamp: map['timestamp'],
        points: map['points']);
  }

  @override
  String toString() {
    return 'Prediction(id: $id, userId: $userId, year: $year, round: $round, winnerId: $winnerId, podiumIds: $podiumIds, fastestLapId: $fastestLapId, timestamp: $timestamp, points: $points)';
  }
}
