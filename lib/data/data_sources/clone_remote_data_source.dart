import 'dart:convert';

import 'package:redrotapp/data/core/api_client.dart';
import 'package:redrotapp/data/core/api_constants.dart';
import 'package:redrotapp/data/models/clones_result_model.dart';

abstract class CloneRemoteDataSource {
  Future<ClonesResultModel> getClones(int page);
  Future<ClonesResultModel> getVerifyNeededClones(int page);
  Future<ClonesResultModel> getCompletedClones(int page);
}

class CloneRemoteDataSourceImpl extends CloneRemoteDataSource {
  final ApiClient client;

  CloneRemoteDataSourceImpl(this.client);

  @override
  Future<ClonesResultModel> getClones(int page) async {
    final response = await client.post(
      "/clone/list",
      body: {
        "page": page,
      },
    );
    final clonesResults = ClonesResultModel.fromJson(response);
    return clonesResults;
  }

  @override
  Future<ClonesResultModel> getVerifyNeededClones(int page) async {
    final response = await client.post(
      "/clone/list/incompleted",
      body: {
        "page": page,
      },
    );
    final clonesResults = ClonesResultModel.fromJson(response);
    return clonesResults;
  }

  @override
  Future<ClonesResultModel> getCompletedClones(int page) async {
    final response = await client.post(
      "/clone/list/completed",
      body: {
        "page": page,
      },
    );
    final clonesResults = ClonesResultModel.fromJson(response);
    return clonesResults;
  }
}
