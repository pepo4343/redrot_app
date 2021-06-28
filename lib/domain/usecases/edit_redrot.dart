import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/edit_redrot_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class EditRedrot extends Usecase<CloneEntity, EditRedrotParam> {
  final CloneRepository cloneRepository;
  EditRedrot(this.cloneRepository);
  @override
  Future<CloneEntity> call(EditRedrotParam params) async {
    return await cloneRepository.editRedrot(
      params.redrotId,
      params.nodalTransgression,
      params.lesionWidth,
      params.color,
    );
  }
}
