class Avatar {
  final String id;
  final int level;

  Avatar({
    required this.id,
    required this.level,
  });

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      id: map['id'] as String,
      level: map['level'] is int
          ? map['level'] as int
          : int.tryParse(map['level'].toString()) ?? 0, // Safeguard against non-integer levels
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
    };
  }
}
