import 'package:redrotapp/data/core/api_client.dart';
import 'package:redrotapp/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class UserRemoteDataSourceImp extends UserRemoteDataSource {
  final ApiClient client;

  UserRemoteDataSourceImp(this.client);
  @override
  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      "/user/login",
      body: {
        "username": username,
        "password": password,
      },
    );

    final clonesResults = UserModel.fromJson(response);
    return clonesResults;
  }
}
