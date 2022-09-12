import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
// import 'package:local_auth_android/local_auth_android.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricUtil {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<List<BiometricType>> getAvailableBiometrics() async {
    final List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
    }
    return availableBiometrics;
  }

  Future<bool> isDeviceSupported() async {
    var canCheckBiometrics = await _auth.canCheckBiometrics;
    var isDeviceSupported = await _auth.isDeviceSupported();

    return canCheckBiometrics || isDeviceSupported;
  }

  Future<bool> authenticate() async {
    // final bool didAuthenticate = await _auth.authenticate(
    //     localizedReason: 'Please authenticate to proceed',
    //     options: const AuthenticationOptions(biometricOnly: true));
    // try {
    //   final bool didAuthenticate = await _auth.authenticate(
    //     localizedReason: 'Please authenticate to proceed',
    //     authMessages: const <AuthMessages>[
    //       AndroidAuthMessages(
    //         signInTitle: 'Oops! Biometric authentication required!',
    //         cancelButton: 'No thanks',
    //       ),
    //       IOSAuthMessages(
    //         cancelButton: 'No thanks',
    //       ),
    //     ],
    //   );
    //   return didAuthenticate;
    // } on PlatformException catch (e) {
    //   if (e.code == auth_error.notAvailable) {
    //     return false;
    //   } else if (e.code == auth_error.notEnrolled) {
    //     return false;
    //   } else if (e.code == auth_error.lockedOut ||
    //       e.code == auth_error.permanentlyLockedOut) {
    //     return false;
    //   } else {
    //     return false; // ...
    //   }
    // }
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: false,
        ),
      );
      // ···
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        return false;
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        return false;
      } else {
        return false;
      }
    }
  }
}
