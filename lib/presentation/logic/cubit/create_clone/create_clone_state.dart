part of 'create_clone_cubit.dart';

abstract class CreateCloneState {}

class CreateCloneInitial extends CreateCloneState {}

class CreateCloneInProgress extends CreateCloneState {}

class CreateCloneSuccess extends CreateCloneState {
  CloneEntity cloneEntity;
  CreateCloneSuccess({
    required this.cloneEntity,
  });
}

class CreateCloneFailure extends CreateCloneState {}
