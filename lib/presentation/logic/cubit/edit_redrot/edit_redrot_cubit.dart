import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flare_flutter/base/actor_drawable.dart';
import 'package:http/http.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/edit_redrot_param.dart';
import 'package:redrotapp/domain/usecases/edit_redrot.dart';

part 'edit_redrot_state.dart';

class EditRedrotCubit extends Cubit<EditRedrotState> {
  EditRedrot editRedrot;

  EditRedrotCubit({
    required this.editRedrot,
  }) : super(EditRedrotInitial());

  void edit(
    String redrotId,
    int nodalTransgression,
    double lesionWidth,
    int color,
  ) async {
    emit(EditRedrotInProgress());
    try {
      final clone = await editRedrot(EditRedrotParam(
        redrotId: redrotId,
        color: color,
        lesionWidth: lesionWidth,
        nodalTransgression: nodalTransgression,
      ));

      final redrot =
          clone.redrot.firstWhere((element) => element.redrotId == redrotId);
      emit(EditRedrotSuccess(cloneEntity: clone, redrotEntity: redrot));
    } on AppError catch (e) {
      print(e);

      emit(EditRedrotFailure());
    }
  }

  void set(
    String redrotId,
    int nodalTransgression,
    double lesionWidth,
    int color,
  ) {
    emit(EditRedrotReady(
      redrotId: redrotId,
      nodalTransgression: nodalTransgression,
      lesionWidth: lesionWidth,
      color: color,
    ));
  }

  void reset() {
    emit(EditRedrotInitial());
  }
}
