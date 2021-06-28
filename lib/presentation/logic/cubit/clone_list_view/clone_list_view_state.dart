import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';

abstract class CloneListViewFetchState {}

class CloneListViewFetchInitial extends CloneListViewFetchState {}

class CloneListViewFetchEmpty extends CloneListViewFetchState {}

class CloneListViewFetchInProgress extends CloneListViewFetchState {}

class CloneListViewFetchNextPageInProgress extends CloneListViewFetchState {
  final List<CloneEntity> clones;
  CloneListViewFetchNextPageInProgress({
    required this.clones,
  });
}

class CloneListViewFetchSuccess extends CloneListViewFetchState {
  final List<CloneEntity> clones;
  CloneListViewFetchSuccess({
    required this.clones,
  });
}

class CloneListViewFetchFailure extends CloneListViewFetchState {}
