import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';

abstract class CloneRepository {
  Future<ClonesResultEntity> getClones(int page);

  Future<ClonesResultEntity> getVerifyNeededClones(int page);

  Future<ClonesResultEntity> getCompletedClones(int page);

  Future<ClonesResultEntity> getNextClones(String id);

  Future<ClonesResultEntity> getNextVerifyNeededClones(String id);

  Future<ClonesResultEntity> getNextCompletedClones(String id);
}
