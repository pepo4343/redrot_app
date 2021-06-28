import 'package:redrotapp/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> login(String username, String password);
}
