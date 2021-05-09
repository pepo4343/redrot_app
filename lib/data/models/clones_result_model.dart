import 'package:redrotapp/domain/entities/clones_result_entity.dart';

import 'clone_model.dart';

class ClonesResultModel extends ClonesResultEntity {
  late int page;
  late int totalPage;
  late List<CloneModel> results;

  ClonesResultModel({
    required this.page,
    required this.totalPage,
    required this.results,
  }) : super(
          page: page,
          totalPage: totalPage,
          results: results,
        );

  factory ClonesResultModel.fromJson(Map<String, dynamic> json) {
    List<CloneModel> results = [];
    if (json['results'] != null) {
      json['results'].forEach((v) {
        results.add(new CloneModel.fromJson(v));
      });
    }

    return ClonesResultModel(
      page: json['page'],
      totalPage: json['totalPage'],
      results: results,
    );
  }
}
