import 'package:redrotapp/domain/entities/no_param.dart';
import 'package:redrotapp/domain/entities/redrot_id_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class DeleteAll extends Usecase<void, NoParam> {
  final CloneRepository cloneRepository;
  DeleteAll(this.cloneRepository);

  @override
  Future<void> call(NoParam params) async {
    await cloneRepository.deleteAll();
  }
}
