import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/redrot_id_param.dart';
import 'package:redrotapp/domain/usecases/confirm_redrot.dart';
import 'package:redrotapp/presentation/logic/cubit/edit_redrot/edit_redrot_cubit.dart';

part 'confirm_redrot_state.dart';

class ConfirmRedrotCubit extends Cubit<ConfirmRedrotState> {
  final ConfirmRedrot confirmRedrot;
  final EditRedrotCubit editRedrotCubit;
  StreamSubscription? editRedrotStreamSubscription;
  ConfirmRedrotCubit({
    required this.confirmRedrot,
    required this.editRedrotCubit,
  }) : super(ConfirmRedrotInitial()) {
    editRedrotStreamSubscription = editRedrotCubit.stream.listen(
      (editstate) {
        if (editstate is EditRedrotSuccess) {
          emit(
            ConfirmRedrotFetchSuccess(
                clone: editstate.cloneEntity, redrot: editstate.redrotEntity),
          );
        }
      },
    );
  }

  void confirm(String redrotId) async {
    emit(ConfirmRedrotFetchInprogress());
    try {
      final clone = await confirmRedrot(RedrotIdParam(redrotId));

      emit(
        ConfirmRedrotFetchSuccess(
          redrot: clone.redrot
              .firstWhere((element) => element.redrotId == redrotId),
          clone: clone,
        ),
      );
    } on AppError catch (e) {
      print(e);
      emit(ConfirmRedrotFetchFailure());
    }
  }
}
