import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:redrotapp/data/core/api_client.dart';
import 'package:redrotapp/data/data_sources/clone_remote_data_source.dart';
import 'package:redrotapp/data/repositories/clone_repository_impl.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/create_clone.dart';
import 'package:redrotapp/domain/usecases/get_clone_by_id.dart';
import 'package:redrotapp/domain/usecases/get_clones.dart';
import 'package:redrotapp/domain/usecases/get_clones_by_name.dart';
import 'package:redrotapp/domain/usecases/get_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_clones.dart';
import 'package:redrotapp/domain/usecases/get_next_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_verifyneeded.dart';
import 'package:redrotapp/domain/usecases/get_verifyneeded.dart';
import 'package:redrotapp/domain/usecases/upload_redrot_image.dart';

import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerFactory<Client>(() => Client());

  getItInstance.registerFactory<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<CloneRemoteDataSource>(
      () => CloneRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<CloneRepository>(
      () => CloneRespositoryImpl(getItInstance()));

  getItInstance
      .registerLazySingleton<GetClones>(() => GetClones(getItInstance()));

  getItInstance.registerLazySingleton<GetVerifyNeeded>(
      () => GetVerifyNeeded(getItInstance()));

  getItInstance
      .registerLazySingleton<GetCompleted>(() => GetCompleted(getItInstance()));

  getItInstance.registerLazySingleton<GetNextClones>(
      () => GetNextClones(getItInstance()));

  getItInstance.registerLazySingleton<GetClonesByName>(
      () => GetClonesByName(getItInstance()));

  getItInstance.registerLazySingleton<GetNextVerifyNeeded>(
      () => GetNextVerifyNeeded(getItInstance()));

  getItInstance.registerLazySingleton<GetNextCompleted>(
      () => GetNextCompleted(getItInstance()));

  getItInstance.registerLazySingleton<UploadRedrotImage>(
      () => UploadRedrotImage(getItInstance()));

  getItInstance
      .registerLazySingleton<GetCloneById>(() => GetCloneById(getItInstance()));

  getItInstance
      .registerLazySingleton<CreateClone>(() => CreateClone(getItInstance()));

  getItInstance.registerFactory<CloneDetailCubit>(() => CloneDetailCubit(
        createClone: getItInstance(),
        getCloneById: getItInstance(),
      ));
  getItInstance.registerFactory<ImageUploaderCubit>(
      () => ImageUploaderCubit(uploadRedrotImage: getItInstance()));

  getItInstance.registerFactory<CloneListViewCubit>(() => CloneListViewCubit(
        getClonesByName: getItInstance(),
        getClones: getItInstance(),
        getCompleted: getItInstance(),
        getNextClones: getItInstance(),
        getNextCompleted: getItInstance(),
        getNextVerifyNeeded: getItInstance(),
        getVerifyNeeded: getItInstance(),
      ));
}
