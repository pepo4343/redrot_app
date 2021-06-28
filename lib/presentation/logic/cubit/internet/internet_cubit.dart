import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity/connectivity.dart';
part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;
  InternetCubit({
    required this.connectivity,
  }) : super(InternetInitial()) {
    connectivityStreamSubscription = connectivity.onConnectivityChanged.listen(
      (event) {
        if (event == ConnectivityResult.none) {
          emitInternetDisconnected();
        } else {
          emitInternetConnected();
        }
      },
    );
  }

  void emitInternetConnected() => emit(InternetConnected());

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }
}
