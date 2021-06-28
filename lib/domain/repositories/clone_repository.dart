import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';

abstract class CloneRepository {
  Future<ClonesResultEntity> getClones(int page);

  Future<ClonesResultEntity> getClonesByName(String name);

  Future<CloneEntity> getClonesById(String id);

  Future<ClonesResultEntity> getVerifyNeededClones(int page);

  Future<ClonesResultEntity> getCompletedClones(int page);

  Future<ClonesResultEntity> getNextClones(String id);

  Future<ClonesResultEntity> getNextVerifyNeededClones(String id);

  Future<ClonesResultEntity> getNextCompletedClones(String id);

  Future<CloneEntity> createClone(String cloneName);

  Future<CloneEntity> uploadRedrotImage(String cloneId, String imageUrl);

  Future<CloneEntity> confirmRedrot(String redrotId);

  Future<CloneEntity> editRedrot(
    String redrotId,
    int nodalTransgression,
    double lesionWidth,
    int color,
  );
}
