import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:redrotapp/data/core/api_client.dart';
import 'package:redrotapp/data/data_sources/clone_remote_data_source.dart';
import 'package:redrotapp/data/repositories/clone_repository_impl.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/get_clones.dart';
import 'package:redrotapp/domain/usecases/get_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_clones.dart';
import 'package:redrotapp/domain/usecases/get_next_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_verifyneeded.dart';
import 'package:redrotapp/domain/usecases/get_verifyneeded.dart';
import 'package:redrotapp/presentation/logic/cubit/all/all_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/completed/completed_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/verify_needed/verify_needed_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance
      .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<CloneRemoteDataSource>(
      () => CloneRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<CloneRepository>(
      () => CloneRespositoryImpl(getItInstance()));

  getItInstance.registerFactory<GetClones>(() => GetClones(getItInstance()));

  getItInstance
      .registerFactory<GetVerifyNeeded>(() => GetVerifyNeeded(getItInstance()));

  getItInstance
      .registerFactory<GetCompleted>(() => GetCompleted(getItInstance()));

  getItInstance
      .registerFactory<GetNextClones>(() => GetNextClones(getItInstance()));

  getItInstance.registerFactory<GetNextVerifyNeeded>(
      () => GetNextVerifyNeeded(getItInstance()));

  getItInstance.registerFactory<GetNextCompleted>(
      () => GetNextCompleted(getItInstance()));

  getItInstance.registerFactory<VerifyNeededCubit>(() => VerifyNeededCubit(
        getVerifyNeeded: getItInstance(),
        getNextVerifyNeeded: getItInstance(),
      ));

  getItInstance.registerFactory<CompletedCubit>(() => CompletedCubit(
        getCompleted: getItInstance(),
        getNextCompleted: getItInstance(),
      ));
  getItInstance.registerFactory<AllCubit>(() => AllCubit(
        getClones: getItInstance(),
        getNextClones: getItInstance(),
      ));
}
