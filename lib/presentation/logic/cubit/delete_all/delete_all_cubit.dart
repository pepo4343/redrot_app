import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/no_param.dart';
import 'package:redrotapp/domain/usecases/delete_all.dart';

part 'delete_all_state.dart';

class DeleteAllCubit extends Cubit<DeleteAllState> {
  final DeleteAll deleteAll;
  DeleteAllCubit({
    required this.deleteAll,
  }) : super(DeleteAllInitial());
  void delete() async {
    emit(DeleteAllInProgress());
    try {
      await deleteAll(NoParam());
      emit(DeleteAllSuccess());
    } on AppError catch (e) {
      print(e);
      emit(DeleteAllFailure());
    }
  }
}
