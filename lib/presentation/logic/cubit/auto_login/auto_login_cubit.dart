import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'auto_login_state.dart';

class AutoLoginCubit extends HydratedCubit<AutoLoginState> {
  AutoLoginCubit() : super(AutoLoginInitialize());

  void reset() => emit(AutoLoginDisable());
  void enable(String username, String password) => emit(
        AutoLoginEnable(
          username: username,
          password: password,
        ),
      );
  @override
  AutoLoginState? fromJson(Map<String, dynamic> json) {
    if (json["disable"] == true) {
      return AutoLoginDisable();
    }
    return AutoLoginEnable.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AutoLoginState state) {
    if (state is AutoLoginEnable) {
      return state.toMap();
    }
    return {"disable": true};
  }
}
