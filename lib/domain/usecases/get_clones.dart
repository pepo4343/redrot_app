import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class GetClones extends Usecase<ClonesResultEntity, PageParam> {
  final CloneRepository cloneRepository;
  GetClones(this.cloneRepository);

  Future<ClonesResultEntity> call(PageParam params) async {
    return await cloneRepository.getClones(params.page);
  }
}
