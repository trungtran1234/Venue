import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChecker {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  void Function(bool)? onStatusChanged;

  ConnectivityChecker({this.onStatusChanged}) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    onStatusChanged?.call(result != ConnectivityResult.none);
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}