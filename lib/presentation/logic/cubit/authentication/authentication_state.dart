part of 'authentication_cubit.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationGuestAnthenticated extends AuthenticationState {}

class AuthenticationAnthenticated extends AuthenticationState {
  UserEntity userEntity;
  AuthenticationAnthenticated({required this.userEntity});
}

class AuthenticationUnanthenticated extends AuthenticationState {}
