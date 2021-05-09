import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/usecases/get_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_completed.dart';

import '../fetch_state.dart';

class CompletedCubit extends Cubit<FetchState> {
  final GetCompleted getCompleted;
  final GetNextCompleted getNextCompleted;
  List<CloneEntity> currentClones = [];

  CompletedCubit({
    required this.getCompleted,
    required this.getNextCompleted,
  }) : super(FetchInitial());

  void fetchFirstPage() async {
    emit(FetchInitial());
    final completedClones = await getCompleted(PageParam(1));
    currentClones = completedClones.results;
    if (completedClones.results.isEmpty) {
      emit(FetchEmpty());
    } else {
      emit(FetchSuccess(clones: currentClones));
    }
  }

  void fetchNextPage() async {
    emit(FetchInProgress(clones: currentClones));
    try {
      final cloneId = currentClones.last.cloneId;
      final completedClones = await getNextCompleted(CloneIdParam(cloneId));
      currentClones = [...currentClones, ...completedClones.results];
      emit(FetchSuccess(clones: currentClones));
    } on AppError catch (e) {
      emit(FetchFailure());
    }
  }
}
