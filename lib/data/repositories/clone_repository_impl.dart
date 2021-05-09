import 'package:redrotapp/data/data_sources/clone_remote_data_source.dart';
import 'package:redrotapp/data/models/clones_result_model.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
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
    } on Exception {
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
}
