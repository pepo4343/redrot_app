import 'package:redrotapp/domain/entities/clone_id_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class DeleteClone extends Usecase<void, CloneIdParam> {
  final CloneRepository cloneRepository;
  DeleteClone(this.cloneRepository);

  @override
  Future<void> call(CloneIdParam params) async {
    await cloneRepository.deleteClone(params.cloneID);
  }
}
