import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_name_param.dart';
import 'package:redrotapp/domain/usecases/create_clone.dart';

part 'create_clone_state.dart';

class CreateCloneCubit extends Cubit<CreateCloneState> {
  CreateClone createClone;

  CreateCloneCubit({
    required this.createClone,
  }) : super(CreateCloneInitial());

  void create(String cloneName) async {
    emit(CreateCloneInProgress());
    try {
      final createdClone = await createClone(CloneNameParam(cloneName));
      emit(CreateCloneSuccess(cloneEntity: createdClone));
    } on AppError catch (e) {
      print(e);
      emit(CreateCloneFailure());
    }
  }
}
