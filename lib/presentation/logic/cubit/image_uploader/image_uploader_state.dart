part of 'image_uploader_cubit.dart';

class RedrotImage {
  final String path;
  ImageUploadStatus status;

  RedrotImage({
    required this.path,
    required this.status,
  });

  @override
  String toString() => 'RedrotImage(status: $status)';
}

abstract class ImageUploaderState {
  CloneEntity? clone;
  List<RedrotImage> redrotImages;

  ImageUploaderState({required this.redrotImages, this.clone});
}

class ImageUploaderInitial extends ImageUploaderState {
  ImageUploaderInitial()
      : super(
          redrotImages: [],
        );
}

class ImageUploaderEmpty extends ImageUploaderState {
  CloneEntity? clone;
  List<RedrotImage> redrotImages;
  ImageUploaderEmpty({
    required this.redrotImages,
    required this.clone,
  }) : super(
          redrotImages: redrotImages,
          clone: clone,
        );
}

class ImageUploaderReady extends ImageUploaderState {
  CloneEntity? clone;
  List<RedrotImage> redrotImages;

  ImageUploaderReady({
    required this.redrotImages,
    required this.clone,
  }) : super(
          redrotImages: redrotImages,
          clone: clone,
        );
}

class ImageUploaderUploading extends ImageUploaderState {
  late CloneEntity? clone;
  late List<RedrotImage> redrotImages;

  int totalImages = 0;
  int finishedImages = 0;

  ImageUploaderUploading({
    required List<RedrotImage> redrotImages,
    required CloneEntity clone,
  }) : super(redrotImages: redrotImages, clone: clone) {
    this.clone = clone;
    this.redrotImages = redrotImages;
    totalImages = redrotImages.length;
    finishedImages = redrotImages.fold<int>(
        0,
        (previousValue, element) =>
            element.status == (ImageUploadStatus.Success)
                ? previousValue + 1
                : previousValue);
  }
}

class ImageUploaderSuccess extends ImageUploaderState {
  CloneEntity? clone;
  List<RedrotImage> redrotImages;

  ImageUploaderSuccess({
    required this.redrotImages,
    required this.clone,
  }) : super(
          redrotImages: redrotImages,
          clone: clone,
        );
}

class ImageUploaderFailure extends ImageUploaderState {
  CloneEntity? clone;
  List<RedrotImage> redrotImages;

  ImageUploaderFailure({
    required this.redrotImages,
    required this.clone,
  }) : super(
          redrotImages: redrotImages,
          clone: clone,
        );
}
