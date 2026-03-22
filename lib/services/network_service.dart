import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<InternetStatus>? _internetSubscription;

  NetworkService() {
    _initConnectivity();
  }

  void _initConnectivity() {
    // Initial quick check
    checkConnection();

    // Listen to device connectivity changes (Wi-Fi, Mobile, None)
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none)) {
        _updateConnectionStatus(false);
      } else {
        checkConnection();
      }
    });

    // Listen to actual internet pings
    _internetSubscription = InternetConnection().onStatusChange.listen((status) {
      final hasInternet = status == InternetStatus.connected;
      _updateConnectionStatus(hasInternet);
    });
  }

  Future<void> checkConnection() async {
    bool hasInternet = await InternetConnection().hasInternetAccess;
    _updateConnectionStatus(hasInternet);
  }

  void _updateConnectionStatus(bool hasInternet) {
    if (_isConnected != hasInternet) {
      _isConnected = hasInternet;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    super.dispose();
  }
}
