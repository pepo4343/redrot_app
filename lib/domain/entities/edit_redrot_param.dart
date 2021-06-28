import 'package:equatable/equatable.dart';

class EditRedrotParam extends Equatable {
  final String redrotId;
  final int nodalTransgression;
  final double lesionWidth;
  final int color;
  EditRedrotParam({
    required this.redrotId,
    required this.nodalTransgression,
    required this.lesionWidth,
    required this.color,
  });

  @override
  List<Object?> get props => [
        redrotId,
        nodalTransgression,
        lesionWidth,
        color,
      ];
}
