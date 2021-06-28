import 'dart:convert';

import 'package:redrotapp/data/core/api_client.dart';
import 'package:redrotapp/data/core/api_constants.dart';
import 'package:redrotapp/data/models/clone_model.dart';
import 'package:redrotapp/data/models/clones_result_model.dart';

abstract class CloneRemoteDataSource {
  Future<ClonesResultModel> getClones(int page);
  Future<ClonesResultModel> getClonesByName(String cloneName);
  Future<CloneModel> getClonesByID(String cloneId);
  Future<ClonesResultModel> getVerifyNeededClones(int page);
  Future<ClonesResultModel> getCompletedClones(int page);

  Future<ClonesResultModel> getNextClones(String cloneId);
  Future<ClonesResultModel> getNextVerifyNeededClones(String cloneId);
  Future<ClonesResultModel> getNextCompletedClones(String cloneId);

  Future<CloneModel> createClone(String cloneName);
  Future<CloneModel> uploadRedrotImage(
    String cloneId,
    String imagePath,
  );

  Future<CloneModel> confirmRedrot(String redrotId);
  Future<CloneModel> editRedrot(
    String redrotId,
    int nodalTransgression,
    double lesionWidth,
    int color,
  );
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

  @override
  Future<ClonesResultModel> getNextClones(String cloneId) async {
    final response = await client.post(
      "/clone/list",
      body: {
        "cloneId": cloneId,
      },
    );
    final clonesResults = ClonesResultModel.fromJson(response);
    return clonesResults;
  }

  @override
  Future<ClonesResultModel> getNextCompletedClones(String cloneId) async {
    final response = await client.post(
      "/clone/list/completed",
      body: {
        "cloneId": cloneId,
      },
    );
    final clonesResults = ClonesResultModel.fromJson(response);
    return clonesResults;
  }

  @override
  Future<ClonesResultModel> getNextVerifyNeededClones(String cloneId) async {
    final response = await client.post(
      "/clone/list/incompleted",
      body: {
        "cloneId": cloneId,
      },
    );
    final clonesResults = ClonesResultModel.fromJson(response);
    return clonesResults;
  }

  @override
  Future<CloneModel> createClone(String cloneName) async {
    final response = await client.post(
      "/clone/create",
      body: {
        "cloneName": cloneName,
      },
    );
    final cloneResults = CloneModel.fromJson(response);
    return cloneResults;
  }

  @override
  Future<ClonesResultModel> getClonesByName(String cloneName) async {
    final response = await client.post(
      "/clone/list/name",
      body: {
        "cloneName": cloneName,
      },
    );
    final cloneResults = ClonesResultModel.fromJson(response);
    return cloneResults;
  }

  @override
  Future<CloneModel> getClonesByID(String cloneId) async {
    final response = await client.post(
      "/clone/list/id",
      body: {
        "cloneId": cloneId,
      },
    );
    final cloneResults = CloneModel.fromJson(response);
    return cloneResults;
  }

  @override
  Future<CloneModel> uploadRedrotImage(String cloneId, String imagePath) async {
    final response = await client.fileUploadMultipart(
      "/clone/redrot/add",
      imagePath,
      cloneId,
    );
    final cloneResults = CloneModel.fromJson(response);
    return cloneResults;
  }

  @override
  Future<CloneModel> confirmRedrot(String redrotId) async {
    final response = await client.post(
      "/clone/redrot/confirm",
      body: {
        "redrotId": redrotId,
      },
    );
    final cloneResults = CloneModel.fromJson(response);
    return cloneResults;
  }

  @override
  Future<CloneModel> editRedrot(
    String redrotId,
    int nodalTransgression,
    double lesionWidth,
    int color,
  ) async {
    final response = await client.post(
      "/clone/redrot/edit",
      body: {
        "redrotId": redrotId,
        "nodalTransgression": nodalTransgression,
        "lesionWidth": lesionWidth,
        "color": color
      },
    );
    final cloneResults = CloneModel.fromJson(response);
    return cloneResults;
  }
}
