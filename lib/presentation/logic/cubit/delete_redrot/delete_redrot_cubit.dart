import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/redrot_id_param.dart';
import 'package:redrotapp/domain/usecases/delete_redrot.dart';

part 'delete_redrot_state.dart';

class DeleteRedrotCubit extends Cubit<DeleteRedrotState> {
  final DeleteRedrot deleteRedrot;
  DeleteRedrotCubit({
    required this.deleteRedrot,
  }) : super(DeleteRedrotInitial());
  void delete(String redrotId) async {
    emit(DeleteRedrotInProgress());
    try {
      await deleteRedrot(RedrotIdParam(redrotId));
      emit(DeleteRedrotSuccess());
    } on AppError catch (e) {
      print(e);
      emit(DeleteRedrotFailure());
    }
  }
}
