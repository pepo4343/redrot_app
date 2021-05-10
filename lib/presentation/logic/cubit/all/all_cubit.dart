import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/usecases/get_clones.dart';
import 'package:redrotapp/domain/usecases/get_next_clones.dart';

import '../fetch_state.dart';

class AllCubit extends Cubit<FetchState> {
  final GetClones getClones;
  final GetNextClones getNextClones;
  List<CloneEntity> currentClones = [];
  bool isFetching = false;

  AllCubit({
    required this.getClones,
    required this.getNextClones,
  }) : super(FetchInitial());

  void fetchFirstPage() async {
    emit(FetchInitial());
    final allClones = await getClones(PageParam(1));
    currentClones = allClones.results;
    if (allClones.results.isEmpty) {
      emit(FetchEmpty());
    } else {
      emit(FetchSuccess(clones: currentClones));
    }
  }

  void fetchNextPage() async {
    if (isFetching) {
      return;
    }
    emit(FetchInProgress(clones: currentClones));
    try {
      isFetching = true;
      final cloneId = currentClones.last.cloneId;
      final allClones = await getNextClones(CloneIdParam(cloneId));
      Future.delayed(Duration(milliseconds: 500), () {
        isFetching = false;
      });
      currentClones = [...currentClones, ...allClones.results];
      emit(FetchSuccess(clones: currentClones));
    } on AppError catch (e) {
      emit(FetchFailure());
    }
  }
}
