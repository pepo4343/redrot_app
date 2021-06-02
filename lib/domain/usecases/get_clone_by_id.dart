import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class GetCloneById extends Usecase<CloneEntity, CloneIdParam> {
  final CloneRepository cloneRepository;
  GetCloneById(this.cloneRepository);

  @override
  Future<CloneEntity> call(CloneIdParam params) async {
    return await cloneRepository.getClonesById(params.cloneID);
  }
}
