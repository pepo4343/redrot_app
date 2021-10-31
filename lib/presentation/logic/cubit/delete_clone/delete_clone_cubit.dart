import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/usecases/delete_clone.dart';

part 'delete_clone_state.dart';

class DeleteCloneCubit extends Cubit<DeleteCloneState> {
  final DeleteClone deleteClone;
  DeleteCloneCubit({
    required this.deleteClone,
  }) : super(DeleteCloneInitial());

  void delete(String cloneId) async {
    emit(DeleteCloneInProgress());
    try {
      await deleteClone(CloneIdParam(cloneId));
      emit(DeleteCloneSuccess());
    } on AppError catch (e) {
      print(e);
      emit(DeleteCloneFailure());
    }
  }
}
