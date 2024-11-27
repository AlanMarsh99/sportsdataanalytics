class Avatar {
  final String name;
  final int level;

  Avatar({
    required this.name,
    required this.level,
  });

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      name: map['name'] as String,
      level: map['level'] is int
          ? map['level'] as int
          : int.tryParse(map['level'].toString()) ?? 0, // Safeguard against non-integer levels
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
    };
  }
}
