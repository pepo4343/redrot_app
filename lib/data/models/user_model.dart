import 'package:redrotapp/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  String? userId;
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? message;

  UserModel(
      {this.userId,
      this.username,
      this.password,
      this.firstName,
      this.lastName,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.message})
      : super(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
          userId: userId,
          username: username,
          message: message,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'],
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      message: json['message'],
    );
  }
}
