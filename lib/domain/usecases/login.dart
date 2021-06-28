import 'package:redrotapp/domain/entities/login_param.dart';
import 'package:redrotapp/domain/entities/user_entity.dart';
import 'package:redrotapp/domain/repositories/user_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class Login extends Usecase<UserEntity, LoginParam> {
  final UserRepository userRepository;
  Login(this.userRepository);
  @override
  Future<UserEntity> call(LoginParam params) async {
    return await userRepository.login(params.username, params.password);
  }
}
