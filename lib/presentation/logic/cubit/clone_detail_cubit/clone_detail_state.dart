import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';

abstract class CloneDetailFetchState {
  final CloneEntity? clone;
  const CloneDetailFetchState({this.clone});
}

class CloneDetailFetchInitial extends CloneDetailFetchState {}

class CloneDetailFetchEmpty extends CloneDetailFetchState {
  final CloneEntity clone;
  CloneDetailFetchEmpty({
    required this.clone,
  }) : super(clone: clone);
}

class CloneDetailFetchInProgress extends CloneDetailFetchState {}

class CloneDetailFetchSuccess extends CloneDetailFetchState {
  final CloneEntity clone;
  CloneDetailFetchSuccess({
    required this.clone,
  }) : super(clone: clone);
}

class CloneDetailFetchFailure extends CloneDetailFetchState {}
