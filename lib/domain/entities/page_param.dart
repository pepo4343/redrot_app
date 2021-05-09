import 'package:equatable/equatable.dart';

class PageParam extends Equatable {
  final int page;
  PageParam(this.page);

  @override
  // TODO: implement props
  List<Object?> get props => [page];
}
