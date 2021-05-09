import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';

abstract class FetchState extends Equatable {
  const FetchState();

  @override
  List<Object> get props => [];
}

class FetchInitial extends FetchState {}

class FetchEmpty extends FetchState {}

class FetchInProgress extends FetchState {
  final List<CloneEntity> clones;
  FetchInProgress({
    required this.clones,
  });
}

class FetchSuccess extends FetchState {
  final List<CloneEntity> clones;
  FetchSuccess({
    required this.clones,
  });
}

class FetchFailure extends FetchState {}
