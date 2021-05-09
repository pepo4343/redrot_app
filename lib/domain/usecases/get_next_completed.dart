import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class GetNextCompleted extends Usecase<ClonesResultEntity, CloneIdParam> {
  final CloneRepository cloneRepository;
  GetNextCompleted(this.cloneRepository);

  @override
  Future<ClonesResultEntity> call(CloneIdParam params) async {
    return await cloneRepository.getNextCompletedClones(params.cloneID);
  }
}
