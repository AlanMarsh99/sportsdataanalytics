import 'package:cloud_firestore/cloud_firestore.dart';

class League {
  String id;
  String name;
  List<String> userIds;
  Timestamp createdAt;

  League({
    required this.id,
    required this.name,
    required this.userIds,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userIds': userIds,
      'createdAt': createdAt,
    };
  }

  factory League.fromMap(Map<String, dynamic> map) {
    return League(
      id: map['id'],
      name: map['name'],
      userIds: List<String>.from(map['userIds']),
      createdAt: map['createdAt'],
    );
  }

  @override
  String toString() {
    return 'UserApp(id: $id, name: $name, userIds: $userIds, createdAt: $createdAt)';
  }
}
