import 'package:redrotapp/domain/entities/clone_name_param.dart';
import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class GetClonesByName extends Usecase<ClonesResultEntity, CloneNameParam> {
  final CloneRepository cloneRepository;
  GetClonesByName(this.cloneRepository);

  @override
  Future<ClonesResultEntity> call(CloneNameParam params) async {
    return await cloneRepository.getClonesByName(params.cloneName);
  }
}
