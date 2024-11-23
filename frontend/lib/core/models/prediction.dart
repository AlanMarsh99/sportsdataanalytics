import 'package:cloud_firestore/cloud_firestore.dart';

class Prediction {
  String? id;
  String userId;
  int year;
  int round;
  String? winnerId;
  List<String>? podiumIds;
  String? fastestLapId;
  Timestamp? timestamp;
  int? points;


  Prediction({
    this.id,
    required this.userId,
    required this.year,
    required this.round,
    this.winnerId,
    this.podiumIds,
    this.fastestLapId,
    this.timestamp,
    this.points
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'year': year,
      'round': round,
      'winnerId': winnerId,
      'podiumIds': podiumIds,
      'fastestLapId': fastestLapId,
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
      winnerId: map['winnerId'],
      podiumIds: List<String>.from(map['podiumIds']),
      fastestLapId: map['fastestLapId'],
      timestamp: map['timestamp'],
      points: map['points']
    );
  }

  @override
  String toString() {
    return 'Prediction(id: $id, userId: $userId, year: $year, round: $round, winnerId: $winnerId, podiumIds: $podiumIds, fastestLapId: $fastestLapId, timestamp: $timestamp, points: $points)';
  }
}
