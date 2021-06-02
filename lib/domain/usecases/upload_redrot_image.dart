import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/image_upload_param.dart';
import 'package:redrotapp/domain/repositories/clone_repository.dart';
import 'package:redrotapp/domain/usecases/usecase.dart';

class UploadRedrotImage extends Usecase<CloneEntity, ImageUploadParam> {
  final CloneRepository cloneRepository;
  UploadRedrotImage(this.cloneRepository);

  @override
  Future<CloneEntity> call(ImageUploadParam params) async {
    return await cloneRepository.uploadRedrotImage(
        params.cloneId, params.imagePath);
  }
}
