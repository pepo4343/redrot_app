import 'package:equatable/equatable.dart';

import 'package:redrotapp/common/enum.dart';

class CloneEntity extends Equatable {
  final String cloneId;
  final String cloneName;
  final DateTime createdAt;
  final List<RedrotEntity> redrot;
  final CategoryEntity? categoryEntity;
  CloneEntity({
    required this.cloneId,
    required this.cloneName,
    required this.createdAt,
    required this.redrot,
    this.categoryEntity,
  });

  @override
  List<Object?> get props => [cloneId, cloneName, createdAt, redrot];

  @override
  bool get stringify => true;
}

class RedrotEntity extends Equatable {
  final ProcessStatus status;
  final String redrotId;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ScoreEntity? score;
  final RawEntity? raw;
  RedrotEntity(
      {required this.status,
      required this.redrotId,
      required this.imageUrl,
      required this.createdAt,
      required this.updatedAt,
      this.score,
      this.raw});

  @override
  List<Object?> get props => [status, redrotId, imageUrl];

  @override
  bool get stringify => true;
}

class ScoreEntity {
  final int nodalTransgressionScore;
  final int lesionWidthScore;
  final int colorScore;
  final int totalScore;

  ScoreEntity({
    required this.nodalTransgressionScore,
    required this.lesionWidthScore,
    required this.colorScore,
    required this.totalScore,
  });
}

class RawEntity {
  final int nodalTransgression;
  final double lesionWidth;
  final int color;

  RawEntity({
    required this.nodalTransgression,
    required this.lesionWidth,
    required this.color,
  });
}

class CategoryEntity {
  final double scoreAvg;
  final int category;
  final String categoryText;

  CategoryEntity({
    required this.scoreAvg,
    required this.category,
    required this.categoryText,
  });
}
