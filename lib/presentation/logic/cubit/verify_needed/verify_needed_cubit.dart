import 'package:bloc/bloc.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/entities/page_param.dart';
import 'package:redrotapp/domain/usecases/get_next_verifyneeded.dart';
import 'package:redrotapp/domain/usecases/get_verifyneeded.dart';
import 'package:redrotapp/presentation/logic/cubit/fetch_state.dart';

class VerifyNeededCubit extends Cubit<FetchState> {
  final GetVerifyNeeded getVerifyNeeded;
  final GetNextVerifyNeeded getNextVerifyNeeded;
  bool isFetching = false;
  List<CloneEntity> currentClones = [];

  VerifyNeededCubit({
    required this.getVerifyNeeded,
    required this.getNextVerifyNeeded,
  }) : super(FetchInitial());

  void fetchFirstPage() async {
    emit(FetchInitial());
    final verifyNeededClones = await getVerifyNeeded(PageParam(1));
    currentClones = verifyNeededClones.results;
    if (verifyNeededClones.results.isEmpty) {
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
      final verifyNeededClones =
          await getNextVerifyNeeded(CloneIdParam(cloneId));
      Future.delayed(Duration(milliseconds: 500), () {
        isFetching = false;
      });

      currentClones = [...currentClones, ...verifyNeededClones.results];
      emit(FetchSuccess(clones: currentClones));
    } on AppError catch (e) {
      emit(FetchFailure());
    }
  }
}
