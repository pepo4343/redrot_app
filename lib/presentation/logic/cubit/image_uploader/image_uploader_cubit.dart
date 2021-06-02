import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:images_picker/images_picker.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/app_error.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/domain/entities/image_upload_param.dart';
import 'package:redrotapp/domain/usecases/upload_redrot_image.dart';

part 'image_uploader_state.dart';

class ImageUploaderCubit extends Cubit<ImageUploaderState> {
  final UploadRedrotImage uploadRedrotImage;
  ImageUploaderCubit({
    required this.uploadRedrotImage,
  }) : super(ImageUploaderInitial());

  CloneEntity? _clone;
  List<RedrotImage> _redrotImages = [];

  void init(CloneEntity clone, List<Media> media) {
    _redrotImages = media
        .map(
          (e) => RedrotImage(path: e.path, status: ImageUploadStatus.Initial),
        )
        .toList();
    _clone = clone;
    emit(ImageUploaderReady(redrotImages: _redrotImages, clone: _clone!));
  }

  void add(List<Media> media) {
    final newRedrotImages = media
        .map(
          (e) => RedrotImage(path: e.path, status: ImageUploadStatus.Initial),
        )
        .toList();

    _redrotImages = [..._redrotImages, ...newRedrotImages];
    emit(ImageUploaderReady(redrotImages: _redrotImages, clone: _clone!));
  }

  void remove(int index) {
    _redrotImages.removeAt(index);
    if (_redrotImages.isEmpty) {
      emit(ImageUploaderEmpty(redrotImages: _redrotImages, clone: _clone!));
    } else {
      emit(ImageUploaderReady(redrotImages: _redrotImages, clone: _clone!));
    }
  }

  void upload() async {
    if (_clone == null) {
      return;
    }
    _redrotImages = _redrotImages
        .map(
            (e) => RedrotImage(path: e.path, status: ImageUploadStatus.Waiting))
        .toList();
    emit(ImageUploaderUploading(redrotImages: _redrotImages, clone: _clone!));

    bool isError = false;
    for (int i = 0; i < _redrotImages.length; i++) {
      final _redrotImage = _redrotImages[i];
      _redrotImage.status = ImageUploadStatus.Uploading;
      try {
        await uploadRedrotImage(ImageUploadParam(
            cloneId: _clone!.cloneId, imagePath: _redrotImage.path));
        _redrotImage.status = ImageUploadStatus.Success;
        emit(ImageUploaderUploading(
            redrotImages: _redrotImages, clone: _clone!));
      } on AppError {
        isError = true;
        _redrotImage.status = ImageUploadStatus.Failure;
        emit(ImageUploaderUploading(
            redrotImages: _redrotImages, clone: _clone!));
      }
    }

    if (!isError) {
      emit(ImageUploaderSuccess(redrotImages: _redrotImages, clone: _clone!));
    } else {
      emit(ImageUploaderFailure(redrotImages: _redrotImages, clone: _clone!));
    }
    await Future.delayed(Duration(seconds: 5));
    _redrotImages = _redrotImages
        .where((element) => element.status != ImageUploadStatus.Success)
        .toList();
    if (_redrotImages.isEmpty) {
      emit(ImageUploaderEmpty(redrotImages: _redrotImages, clone: _clone!));
    } else {
      emit(ImageUploaderReady(redrotImages: _redrotImages, clone: _clone!));
    }
  }

  void reset() {
    _redrotImages = [];
    emit(ImageUploaderEmpty(redrotImages: _redrotImages, clone: _clone!));
  }
}
