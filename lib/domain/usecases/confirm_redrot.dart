import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/redrot_id_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class ConfirmRedrot extends Usecase<CloneEntity, RedrotIdParam> {
  final CloneRepository cloneRepository;
  ConfirmRedrot(this.cloneRepository);

  @override
  Future<CloneEntity> call(RedrotIdParam params) async {
    return await cloneRepository.confirmRedrot(params.redrotId);
  }
}
