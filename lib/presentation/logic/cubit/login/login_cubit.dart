import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/login_param.dart';
import 'package:redrotapp/domain/entities/user_entity.dart';
import 'package:redrotapp/domain/usecases/login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Login login;
  LoginCubit({
    required this.login,
  }) : super(LoginInitial());

  void fetch(String username, String password) async {
    emit(LoginInProgress());
    try {
      final loggedInUser =
          await login(LoginParam(username: username, password: password));
      if (loggedInUser.userId != null) {
        emit(LoginSuccessful(userEntity: loggedInUser));
      } else {
        emit(LoginUnsuccessful(message: loggedInUser.message!));
      }
    } on AppError {
      emit(LoginFailure());
    }
  }
}
