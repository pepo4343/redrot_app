import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/common/functions.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';

class CloneModel extends CloneEntity {
  late String cloneId;
  late String cloneName;
  late DateTime createdAt;
  late DateTime updatedAt;
  late int iV;
  late List<RedrotModel> redrot;
  late CategoryModel? categories;

  CloneModel({
    required this.cloneId,
    required this.cloneName,
    required this.createdAt,
    required this.updatedAt,
    required this.iV,
    required this.redrot,
    this.categories,
  }) : super(
          cloneId: cloneId,
          cloneName: cloneName,
          createdAt: createdAt,
          redrot: redrot,
          categoryEntity: categories,
        );

  factory CloneModel.fromJson(Map<String, dynamic> json) {
    List<RedrotModel> redrot = [];
    if (json['redrot'] != null) {
      json['redrot'].forEach((v) {
        redrot.add(new RedrotModel.fromJson(v));
      });
    }

    return CloneModel(
        cloneId: json['_id'],
        cloneName: json['cloneName'],
        redrot: redrot,
        categories: json['categoryData'] != null
            ? CategoryModel.fromJson(json['categoryData'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        iV: json['__v']);
  }
}

class RedrotModel extends RedrotEntity {
  late ScoreModel? score;
  late RawModel? raw;
  late ProcessStatus status;
  late String redrotId;
  late String imageUrl;
  late String imageName;
  late DateTime createdAt;
  late DateTime updatedAt;

  RedrotModel(
      {required this.status,
      required this.redrotId,
      required this.imageUrl,
      required this.imageName,
      required this.createdAt,
      required this.updatedAt,
      this.score,
      this.raw})
      : super(
          redrotId: redrotId,
          imageUrl: imageUrl,
          status: status,
          raw: raw,
          score: score,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory RedrotModel.fromJson(Map<String, dynamic> json) {
    return RedrotModel(
      score: (json['score'] != null
          ? new ScoreModel.fromJson(json['score'])
          : null),
      raw: (json['raw'] != null ? new RawModel.fromJson(json['raw']) : null),
      status: toProcessStatus(json['status']),
      redrotId: json['_id'],
      imageUrl: json['imageUrl'],
      imageName: json['imageName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ScoreModel extends ScoreEntity {
  late int nodalTransgressionScore;
  late int lesionWidthScore;
  late int colorScore;
  late int totalScore;

  ScoreModel({
    required this.nodalTransgressionScore,
    required this.lesionWidthScore,
    required this.colorScore,
    required this.totalScore,
  }) : super(
          colorScore: colorScore,
          nodalTransgressionScore: nodalTransgressionScore,
          lesionWidthScore: lesionWidthScore,
          totalScore: totalScore,
        );

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      nodalTransgressionScore: json['nodalTransgressionScore'],
      lesionWidthScore: json['lesionWidthScore'],
      colorScore: json['colorScore'],
      totalScore: json['totalScore'],
    );
  }
}

class RawModel extends RawEntity {
  late int nodalTransgression;
  late double lesionWidth;
  late int color;

  RawModel({
    required this.nodalTransgression,
    required this.lesionWidth,
    required this.color,
  }) : super(
          color: color,
          lesionWidth: lesionWidth,
          nodalTransgression: nodalTransgression,
        );

  factory RawModel.fromJson(Map<String, dynamic> json) {
    return RawModel(
      nodalTransgression: json['nodalTransgression'],
      lesionWidth: json['lesionWidth'],
      color: json['color'],
    );
  }
}

class CategoryModel extends CategoryEntity {
  late double scoreAvg;
  late int category;
  late String categoryText;

  CategoryModel({
    required this.scoreAvg,
    required this.category,
    required this.categoryText,
  }) : super(
          category: category,
          categoryText: categoryText,
          scoreAvg: scoreAvg,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      scoreAvg: json['scoreAvg'].toDouble(),
      category: json['category'],
      categoryText: json['categoryText'],
    );
  }
}
