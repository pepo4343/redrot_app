import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_name_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class CreateClone extends Usecase<CloneEntity, CloneNameParam> {
  final CloneRepository cloneRepository;
  CreateClone(this.cloneRepository);

  @override
  Future<CloneEntity> call(CloneNameParam params) async {
    return await cloneRepository.createClone(params.cloneName);
  }
}
