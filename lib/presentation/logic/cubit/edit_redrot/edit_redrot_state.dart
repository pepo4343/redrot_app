part of 'edit_redrot_cubit.dart';

abstract class EditRedrotState {}

class EditRedrotInitial extends EditRedrotState {}

class EditRedrotReady extends EditRedrotState {
  final String redrotId;
  final int nodalTransgression;
  final double lesionWidth;
  final int color;
  EditRedrotReady({
    required this.redrotId,
    required this.nodalTransgression,
    required this.lesionWidth,
    required this.color,
  });
}

class EditRedrotInProgress extends EditRedrotState {}

class EditRedrotSuccess extends EditRedrotState {
  CloneEntity cloneEntity;
  RedrotEntity redrotEntity;
  EditRedrotSuccess({
    required this.cloneEntity,
    required this.redrotEntity,
  });
}

class EditRedrotFailure extends EditRedrotState {}
