import 'package:bloc/bloc.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/entities/clone_name_param.dart';
import 'package:redrotapp/domain/usecases/create_clone.dart';
import 'package:redrotapp/domain/usecases/get_clone_by_id.dart';
import 'package:redrotapp/presentation/widgets/clone_list_view/clone_list_view.dart';
import './clone_detail_state.dart';

class CloneDetailCubit extends Cubit<CloneDetailFetchState> {
  final CreateClone createClone;
  final GetCloneById getCloneById;
  CloneDetailCubit({
    required this.createClone,
    required this.getCloneById,
  }) : super(CloneDetailFetchInitial());

  Future<CloneEntity?> create(String cloneName) async {
    emit(CloneDetailFetchInProgress());
    try {
      final createdClone = await createClone(CloneNameParam(cloneName));
      emit(CloneDetailFetchSuccess(clone: createdClone));
      return createdClone;
    } on AppError catch (e) {
      emit(CloneDetailFetchFailure());
    }
  }

  fetch(String cloneId) async {
    emit(CloneDetailFetchInProgress());
    try {
      final clone = await getCloneById(CloneIdParam(cloneId));
      await Future.delayed(Duration(milliseconds: 200));
      if (clone.redrot.isEmpty) {
        emit(CloneDetailFetchEmpty(clone: clone));
        return;
      }
      emit(CloneDetailFetchSuccess(clone: clone));
    } on AppError catch (e) {
      emit(CloneDetailFetchFailure());
    }
  }
}
