import 'package:equatable/equatable.dart';

import 'package:redrotapp/domain/entities/clone_entity.dart';

class ClonesResultEntity extends Equatable {
  final int page;
  final int totalPage;
  final List<CloneEntity> results;

  ClonesResultEntity({
    required this.page,
    required this.totalPage,
    required this.results,
  });

  @override
  List<Object?> get props => [page, totalPage, results];

  @override
  bool get stringify => true;
}
