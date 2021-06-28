part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccessful extends LoginState {
  final UserEntity userEntity;
  LoginSuccessful({required this.userEntity});
}

class LoginUnsuccessful extends LoginState {
  final String message;
  LoginUnsuccessful({required this.message});
}

class LoginFailure extends LoginState {}
