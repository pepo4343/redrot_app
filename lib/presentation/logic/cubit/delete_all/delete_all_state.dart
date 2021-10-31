part of 'delete_all_cubit.dart';

abstract class DeleteAllState {}

class DeleteAllInitial extends DeleteAllState {}

class DeleteAllInProgress extends DeleteAllState {}

class DeleteAllSuccess extends DeleteAllState {}

class DeleteAllFailure extends DeleteAllState {}
