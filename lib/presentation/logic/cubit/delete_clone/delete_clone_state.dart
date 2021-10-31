part of 'delete_clone_cubit.dart';

abstract class DeleteCloneState {}

class DeleteCloneInitial extends DeleteCloneState {}

class DeleteCloneInProgress extends DeleteCloneState {}

class DeleteCloneSuccess extends DeleteCloneState {}

class DeleteCloneFailure extends DeleteCloneState {}
