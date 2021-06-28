part of 'confirm_redrot_cubit.dart';

abstract class ConfirmRedrotState {}

class ConfirmRedrotInitial extends ConfirmRedrotState {}

class ConfirmRedrotFetchInprogress extends ConfirmRedrotState {}

class ConfirmRedrotFetchSuccess extends ConfirmRedrotState {
  final RedrotEntity redrot;
  final CloneEntity clone;
  ConfirmRedrotFetchSuccess({
    required this.redrot,
    required this.clone,
  });
}

class ConfirmRedrotFetchFailure extends ConfirmRedrotState {}
