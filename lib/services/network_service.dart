import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService extends ChangeNotifier with WidgetsBindingObserver {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<InternetStatus>? _internetSubscription;
  Timer? _debounceTimer;

  NetworkService() {
    WidgetsBinding.instance.addObserver(this);
    _initConnectivity();
  }

  void _initConnectivity() {
    checkConnection();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (results.contains(ConnectivityResult.none)) {
        _updateConnectionStatus(false);
      } else {
        checkConnection();
      }
    });

    _internetSubscription = InternetConnection().onStatusChange.listen((
      status,
    ) {
      final hasInternet = status == InternetStatus.connected;
      _updateConnectionStatus(hasInternet);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-verify immediately on app resume
      checkConnection();
    }
  }

  Future<void> checkConnection() async {
    bool hasInternet = await InternetConnection().hasInternetAccess;
    _updateConnectionStatus(hasInternet);
  }

  void _updateConnectionStatus(bool hasInternet) {
    if (_isConnected == hasInternet) {
      _debounceTimer?.cancel();
      return;
    }

    if (hasInternet) {
      _debounceTimer?.cancel();
      _isConnected = true;
      notifyListeners();
    } else {
      // Small debounce before reporting "no internet" to avoid false positives on resume or transient state
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 2), () async {
        bool stillDisconnected =
            !(await InternetConnection().hasInternetAccess);
        if (stillDisconnected && _isConnected) {
          _isConnected = false;
          notifyListeners();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
