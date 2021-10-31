import 'package:redrotapp/domain/entities/redrot_id_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class DeleteRedrot extends Usecase<void, RedrotIdParam> {
  final CloneRepository cloneRepository;
  DeleteRedrot(this.cloneRepository);

  @override
  Future<void> call(RedrotIdParam params) async {
    await cloneRepository.deleteRedrot(params.redrotId);
  }
}
