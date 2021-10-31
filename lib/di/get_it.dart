import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:redrotapp/data/core/api_client.dart';
import 'package:redrotapp/data/data_sources/clone_remote_data_source.dart';
import 'package:redrotapp/data/data_sources/user_remote_data_source.dart';
import 'package:redrotapp/data/repositories/clone_repository_impl.dart';
import 'package:redrotapp/data/repositories/user_repository_impl.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/repositories/user_repository.dart';
import 'package:redrotapp/domain/usecases/confirm_redrot.dart';
import 'package:redrotapp/domain/usecases/create_clone.dart';
import 'package:redrotapp/domain/usecases/delete_all.dart';
import 'package:redrotapp/domain/usecases/delete_clone.dart';
import 'package:redrotapp/domain/usecases/delete_redrot.dart';
import 'package:redrotapp/domain/usecases/edit_redrot.dart';
import 'package:redrotapp/domain/usecases/get_clone_by_id.dart';
import 'package:redrotapp/domain/usecases/get_clones.dart';
import 'package:redrotapp/domain/usecases/get_clones_by_name.dart';
import 'package:redrotapp/domain/usecases/get_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_clones.dart';
import 'package:redrotapp/domain/usecases/get_next_completed.dart';
import 'package:redrotapp/domain/usecases/get_next_verifyneeded.dart';
import 'package:redrotapp/domain/usecases/get_verifyneeded.dart';
import 'package:redrotapp/domain/usecases/login.dart';
import 'package:redrotapp/domain/usecases/upload_redrot_image.dart';
import 'package:redrotapp/presentation/logic/cubit/authentication/authentication_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/auto_login/auto_login_cubit.dart';

import 'package:redrotapp/presentation/logic/cubit/clone_detail_cubit/clone_detail_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/confirm_redrot/confirm_redrot_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/create_clone/create_clone_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_all/delete_all_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_clone/delete_clone_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_redrot/delete_redrot_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/edit_redrot/edit_redrot_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/login/login_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerFactory<Client>(() => Client());

  getItInstance.registerFactory<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<CloneRemoteDataSource>(
      () => CloneRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImp(getItInstance()));

  getItInstance.registerLazySingleton<CloneRepository>(
      () => CloneRespositoryImpl(getItInstance()));

  getItInstance.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getItInstance()));

  getItInstance.registerLazySingleton<Login>(() => Login(getItInstance()));

  getItInstance
      .registerLazySingleton<GetClones>(() => GetClones(getItInstance()));

  getItInstance.registerLazySingleton<GetVerifyNeeded>(
      () => GetVerifyNeeded(getItInstance()));

  getItInstance
      .registerLazySingleton<GetCompleted>(() => GetCompleted(getItInstance()));

  getItInstance
      .registerLazySingleton<DeleteClone>(() => DeleteClone(getItInstance()));

  getItInstance
      .registerLazySingleton<DeleteRedrot>(() => DeleteRedrot(getItInstance()));

  getItInstance
      .registerLazySingleton<DeleteAll>(() => DeleteAll(getItInstance()));

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

  getItInstance
      .registerLazySingleton<EditRedrot>(() => EditRedrot(getItInstance()));

  getItInstance.registerLazySingleton<ConfirmRedrot>(
      () => ConfirmRedrot(getItInstance()));

  getItInstance.registerFactory<CloneDetailCubit>(() => CloneDetailCubit(
        createClone: getItInstance(),
        getCloneById: getItInstance(),
      ));

  getItInstance.registerFactory<DeleteCloneCubit>(
    () => DeleteCloneCubit(
      deleteClone: getItInstance(),
    ),
  );

  getItInstance.registerFactory<DeleteRedrotCubit>(
    () => DeleteRedrotCubit(
      deleteRedrot: getItInstance(),
    ),
  );

  getItInstance.registerFactory<DeleteAllCubit>(
    () => DeleteAllCubit(
      deleteAll: getItInstance(),
    ),
  );
  getItInstance.registerFactory<ImageUploaderCubit>(
      () => ImageUploaderCubit(uploadRedrotImage: getItInstance()));

  getItInstance.registerFactory<ConfirmRedrotCubit>(() => ConfirmRedrotCubit(
      confirmRedrot: getItInstance(), editRedrotCubit: getItInstance()));

  getItInstance.registerFactory<EditRedrotCubit>(
      () => EditRedrotCubit(editRedrot: getItInstance()));
  getItInstance.registerFactory<CreateCloneCubit>(
      () => CreateCloneCubit(createClone: getItInstance()));

  getItInstance
      .registerFactory<LoginCubit>(() => LoginCubit(login: getItInstance()));

  getItInstance
      .registerFactory<AuthenticationCubit>(() => AuthenticationCubit());

  getItInstance.registerFactory<AutoLoginCubit>(() => AutoLoginCubit());

  getItInstance.registerFactory<CloneListViewCubit>(
    () => CloneListViewCubit(
      getClonesByName: getItInstance(),
      getClones: getItInstance(),
      getCompleted: getItInstance(),
      getNextClones: getItInstance(),
      getNextCompleted: getItInstance(),
      getNextVerifyNeeded: getItInstance(),
      getVerifyNeeded: getItInstance(),
    ),
  );
}
