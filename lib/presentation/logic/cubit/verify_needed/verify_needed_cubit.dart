import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clones_result_entity.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/usecases/get_verifyneeded.dart';
import 'package:redrotapp/presentation/logic/cubit/fetch_state.dart';

class VerifyNeededCubit extends Cubit<FetchState> {
  final GetVerifyNeeded getVerifyNeeded;

  List<CloneEntity> currentClones = [];
  late int nextPage;

  VerifyNeededCubit({required this.getVerifyNeeded}) : super(FetchInitial());

  void fetchFirstPage() async {
    emit(FetchInitial());
    final verifyNeededClones = await getVerifyNeeded(PageParam(1));
    nextPage = verifyNeededClones.page + 1;
    currentClones = verifyNeededClones.results;
    if (verifyNeededClones.results.isEmpty) {
      emit(FetchEmpty());
    } else {
      emit(FetchSuccess(clones: currentClones));
    }
  }

  void fetchNextPage() async {
    emit(FetchInProgress(clones: currentClones));
    try {
      final verifyNeededClones = await getVerifyNeeded(PageParam(nextPage));
      if (verifyNeededClones.page <= verifyNeededClones.totalPage) {
        nextPage = verifyNeededClones.page + 1;
      }
      currentClones = [...currentClones, ...verifyNeededClones.results];
      emit(FetchSuccess(clones: currentClones));
    } on AppError catch (e) {
      emit(FetchFailure());
    }
  }
}
