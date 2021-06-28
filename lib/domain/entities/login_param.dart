import 'package:equatable/equatable.dart';

class LoginParam extends Equatable {
  final String username;
  final String password;
  LoginParam({
    required this.username,
    required this.password,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [username, password];
}
