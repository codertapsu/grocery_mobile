import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";
import "package:get/route_manager.dart";

class ConnectivityUtil {
  static void _notify(String message, bool noConnection) {
    Get.snackbar(
      'Internet Connection',
      message,
      icon: Icon(
        noConnection ? Icons.signal_wifi_statusbar_null : Icons.wifi,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void configureConnectivityStream() {
    bool noConnection = false;
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        switch (result) {
          case ConnectivityResult.wifi:
            {
              if (noConnection) {
                noConnection = false;
                _notify('Internet Connection With Wifi.', noConnection);
              }
              break;
            }
          case ConnectivityResult.mobile:
            {
              if (noConnection) {
                noConnection = false;
                _notify('Internet Connection With Mobile.', noConnection);
              }
              break;
            }
          case ConnectivityResult.ethernet:
            {
              if (noConnection) {
                noConnection = false;
                _notify('Internet Connection With Ethernet.', noConnection);
              }
              break;
            }
          case ConnectivityResult.bluetooth:
            {
              if (noConnection) {
                noConnection = false;
                _notify('Internet Connection With Bluetooth.', noConnection);
              }
              break;
            }
          case ConnectivityResult.none:
            {
              if (!noConnection) {
                noConnection = true;
                _notify('No Internet Connection.', noConnection);
              }
              break;
            }
        }
      },
    );
  }
}
