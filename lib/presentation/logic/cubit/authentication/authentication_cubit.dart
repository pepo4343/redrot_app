import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/user_entity.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  void emitGuestAuthenticated() => emit(AuthenticationGuestAnthenticated());

  void emitAuthenticated(UserEntity userEntity) =>
      emit(AuthenticationAnthenticated(userEntity: userEntity));

  void reset() => emit(AuthenticationInitial());
}
