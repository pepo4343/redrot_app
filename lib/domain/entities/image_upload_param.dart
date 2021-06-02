import 'package:equatable/equatable.dart';

class ImageUploadParam extends Equatable {
  final String cloneId;
  final String imagePath;
  ImageUploadParam({
    required this.cloneId,
    required this.imagePath,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [cloneId, imagePath];
}
