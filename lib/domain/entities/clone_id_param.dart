import 'package:equatable/equatable.dart';

class CloneIdParam extends Equatable {
  final String cloneID;
  CloneIdParam(this.cloneID);

  @override
  // TODO: implement props
  List<Object?> get props => [cloneID];
}
