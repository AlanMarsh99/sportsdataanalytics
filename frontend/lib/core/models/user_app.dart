class UserApp {
  String? id;
  String? username;
  String? email;

  UserApp({this.id, this.username, this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': username,
      'email': email,
    };
  }

  factory UserApp.fromMap(Map<String, dynamic> map) {
    return UserApp(
      id: map['id'],
      username: map['name'],
      email: map['email'],
    );
  }

  @override
  String toString() {
    return 'UserApp(id: $id, name: $username, email: $email)';
  }
}
