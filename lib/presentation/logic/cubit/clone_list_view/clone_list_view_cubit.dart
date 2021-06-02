import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/entities/clone_name_param.dart';
import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';

import 'package:redrotapp/domain/usecases/get_clones.dart';
import 'package:redrotapp/domain/usecases/get_clones_by_name.dart';
import 'package:redrotapp/domain/usecases/get_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_clones.dart';
import 'package:redrotapp/domain/usecases/get_next_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_verifyneeded.dart';
import 'package:redrotapp/domain/usecases/get_verifyneeded.dart';
import 'clone_list_view_state.dart';

class CloneListViewCubit extends Cubit<CloneListViewFetchState> {
  final GetClones getClones;
  final GetClonesByName getClonesByName;
  final GetNextClones getNextClones;
  final GetCompleted getCompleted;
  final GetNextCompleted getNextCompleted;
  final GetVerifyNeeded getVerifyNeeded;
  final GetNextVerifyNeeded getNextVerifyNeeded;

  List<CloneEntity> currentClones = [];
  bool isFetching = false;

  CloneListViewCubit({
    required this.getClonesByName,
    required this.getClones,
    required this.getNextClones,
    required this.getCompleted,
    required this.getNextCompleted,
    required this.getVerifyNeeded,
    required this.getNextVerifyNeeded,
  }) : super(CloneListViewFetchInitial());

  void fetchByName(String cloneName) async {
    emit(CloneListViewFetchInProgress());
    try {
      final clonesResult = await getClonesByName(CloneNameParam(cloneName));
      await Future.delayed(Duration(milliseconds: 200));
      final clones = clonesResult.results;
      if (clones.isEmpty) {
        emit(CloneListViewFetchEmpty());
      } else {
        emit(CloneListViewFetchSuccess(clones: clones));
      }
    } on AppError catch (e) {
      emit(CloneListViewFetchFailure());
    }
  }

  void fetchFirstPage(CloneType cloneType) async {
    emit(CloneListViewFetchInProgress());

    ClonesResultEntity clonesResult;
    switch (cloneType) {
      case CloneType.All:
        clonesResult = await getClones(PageParam(1));
        break;
      case CloneType.VerifyNeeded:
        clonesResult = await getVerifyNeeded(PageParam(1));
        break;
      case CloneType.Completed:
        clonesResult = await getCompleted(PageParam(1));
        break;
    }

    await Future.delayed(Duration(milliseconds: 200));
    currentClones = clonesResult.results;
    if (clonesResult.results.isEmpty) {
      emit(CloneListViewFetchEmpty());
    } else {
      emit(CloneListViewFetchSuccess(clones: currentClones));
    }
  }

  void fetchNextPage(CloneType cloneType) async {
    if (isFetching) {
      return;
    }
    emit(CloneListViewFetchNextPageInProgress(clones: currentClones));
    try {
      isFetching = true;
      final cloneId = currentClones.last.cloneId;
      ClonesResultEntity clonesResult;
      switch (cloneType) {
        case CloneType.All:
          clonesResult = await getNextClones(CloneIdParam(cloneId));
          break;
        case CloneType.VerifyNeeded:
          clonesResult = await getNextVerifyNeeded(CloneIdParam(cloneId));
          break;
        case CloneType.Completed:
          clonesResult = await getNextCompleted(CloneIdParam(cloneId));
          break;
      }
      Future.delayed(Duration(milliseconds: 1000), () {
        isFetching = false;
      });
      currentClones = [...currentClones, ...clonesResult.results];
      emit(CloneListViewFetchSuccess(clones: currentClones));
    } on AppError catch (e) {
      emit(CloneListViewFetchFailure());
    }
  }
}
