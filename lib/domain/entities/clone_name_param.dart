import 'package:equatable/equatable.dart';

class CloneNameParam extends Equatable {
  final String cloneName;
  CloneNameParam(this.cloneName);

  @override
  // TODO: implement props
  List<Object?> get props => [cloneName];
}
