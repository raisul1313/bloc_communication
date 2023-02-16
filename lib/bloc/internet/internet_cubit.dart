import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_communication/constants/enum.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<ConnectivityResult> monitorInternetConnection() {
    return connectivityStreamSubscription =
      connectivity.onConnectivityChanged.listen((connectivityResult) {
    if (connectivityResult == ConnectivityResult.wifi) {
      emitInternetConnection(ConnectionType.wifi);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      emitInternetConnection(ConnectionType.mobile);
    } else if(connectivityResult == ConnectivityResult.none){
      emitInternetDisconnected();
    }
  });
  }

  void emitInternetConnection(ConnectionType connectionType) =>
      emit(InternetConnected(connectionType: connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());

@override
  Future<void> close() {
    connectivityStreamSubscription!.cancel();
    return super.close();
  }


}
