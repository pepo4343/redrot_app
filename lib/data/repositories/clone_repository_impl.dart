import 'package:redrotapp/data/data_sources/clone_remote_data_source.dart';
import 'package:redrotapp/data/models/clones_result_model.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';

import 'package:redrotapp/domain/repositories/clone_repository.dart';

class CloneRespositoryImpl extends CloneRepository {
  final CloneRemoteDataSource remoteDataSource;

  CloneRespositoryImpl(this.remoteDataSource);

  @override
  Future<ClonesResultModel> getClones(int page) async {
    try {
      final clones = await remoteDataSource.getClones(page);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<ClonesResultModel> getVerifyNeededClones(int page) async {
    try {
      final clones = await remoteDataSource.getVerifyNeededClones(page);
      return clones;
    } on Exception catch (e) {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<ClonesResultModel> getCompletedClones(int page) async {
    try {
      final clones = await remoteDataSource.getCompletedClones(page);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<ClonesResultEntity> getNextClones(String id) async {
    try {
      final clones = await remoteDataSource.getNextClones(id);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<ClonesResultEntity> getNextCompletedClones(String id) async {
    try {
      final clones = await remoteDataSource.getNextCompletedClones(id);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<ClonesResultEntity> getNextVerifyNeededClones(String id) async {
    try {
      final clones = await remoteDataSource.getNextVerifyNeededClones(id);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<CloneEntity> createClone(String cloneName) async {
    try {
      final clones = await remoteDataSource.createClone(cloneName);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<ClonesResultEntity> getClonesByName(String name) async {
    try {
      final clones = await remoteDataSource.getClonesByName(name);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<CloneEntity> getClonesById(String id) async {
    try {
      final clones = await remoteDataSource.getClonesByID(id);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<CloneEntity> uploadRedrotImage(String cloneId, String imageUrl) async {
    try {
      final clones =
          await remoteDataSource.uploadRedrotImage(cloneId, imageUrl);
      return clones;
    } on Exception catch (e) {
      print(e);
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<CloneEntity> confirmRedrot(String redrotId) async {
    try {
      final clones = await remoteDataSource.confirmRedrot(redrotId);
      return clones;
    } on Exception catch (e) {
      print(e);
      throw AppError("Something went wrong.");
    }
  }

  @override
  Future<CloneEntity> editRedrot(String redrotId, int nodalTransgression,
      double lesionWidth, int color) async {
    try {
      final clones = await remoteDataSource.editRedrot(
        redrotId,
        nodalTransgression,
        lesionWidth,
        color,
      );
      return clones;
    } on Exception catch (e) {
      print(e);
      throw AppError("Something went wrong.");
    }
  }
}
