import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/usecases/get_clones.dart';

import '../fetch_state.dart';

class AllCubit extends Cubit<FetchState> {
  final GetClones getClones;

  List<CloneEntity> currentClones = [];
  late int nextPage;
  AllCubit({required this.getClones}) : super(FetchInitial());

  void fetchFirstPage() async {
    emit(FetchInitial());
    final allClones = await getClones(PageParam(1));
    nextPage = allClones.page + 1;
    currentClones = allClones.results;
    if (allClones.results.isEmpty) {
      emit(FetchEmpty());
    } else {
      emit(FetchSuccess(clones: currentClones));
    }
  }

  void fetchNextPage() async {
    emit(FetchInProgress(clones: currentClones));
    try {
      final allClones = await getClones(PageParam(nextPage));
      if (allClones.page <= allClones.totalPage) {
        nextPage = allClones.page + 1;
      }
      currentClones = [...currentClones, ...allClones.results];
      emit(FetchSuccess(clones: currentClones));
    } on AppError catch (e) {
      emit(FetchFailure());
    }
  }
}
