import 'dart:convert';

abstract class AutoLoginState {}

class AutoLoginInitialize extends AutoLoginState {}

class AutoLoginEnable extends AutoLoginState {
  final String username;
  final String password;

  AutoLoginEnable({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory AutoLoginEnable.fromMap(Map<String, dynamic> map) {
    return AutoLoginEnable(
      username: map['username'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AutoLoginEnable.fromJson(String source) =>
      AutoLoginEnable.fromMap(json.decode(source));
}

class AutoLoginDisable extends AutoLoginState {}
