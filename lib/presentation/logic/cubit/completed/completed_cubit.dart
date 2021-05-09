import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/usecases/get_completed.dart';

import '../fetch_state.dart';

class CompletedCubit extends Cubit<FetchState> {
  final GetCompleted getCompleted;

  List<CloneEntity> currentClones = [];
  late int nextPage;

  CompletedCubit({required this.getCompleted}) : super(FetchInitial());

  void fetchFirstPage() async {
    emit(FetchInitial());
    final completedClones = await getCompleted(PageParam(1));
    nextPage = completedClones.page + 1;
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
      final completedClones = await getCompleted(PageParam(nextPage));
      if (completedClones.page <= completedClones.totalPage) {
        nextPage = completedClones.page + 1;
      }
      currentClones = [...currentClones, ...completedClones.results];
      emit(FetchSuccess(clones: currentClones));
    } on AppError catch (e) {
      emit(FetchFailure());
    }
  }
}
