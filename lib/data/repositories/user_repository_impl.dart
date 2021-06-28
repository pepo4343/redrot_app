import 'package:redrotapp/data/data_sources/user_remote_data_source.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/user_entity.dart';
import 'package:redrotapp/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final clones = await remoteDataSource.login(username, password);
      return clones;
    } on Exception {
      throw AppError("Something went wrong.");
    }
  }
}
