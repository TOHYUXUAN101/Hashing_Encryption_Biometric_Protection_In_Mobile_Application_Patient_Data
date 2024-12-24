import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  // Check if the device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint("Error checking device support: $e");
      return false;
    }
  }

  // Check if biometrics can be used on this device
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      debugPrint("Error checking biometrics: $e");
      return false;
    }
  }

  // Get the list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint("Error getting available biometrics: $e");
      return [];
    }
  }

  // Authenticate using biometrics or device credentials
  Future<bool> authenticate({required String reason, bool biometricOnly = false}) async {
    // First, check if biometrics are available on the device
    bool canAuthenticate = await canCheckBiometrics();
    if (!canAuthenticate) {
      debugPrint("Biometrics are not available or not set up on this device.");
      return false;
    }

    try {
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,  // Keeps authentication until successful or canceled
          biometricOnly: biometricOnly,  // Only biometrics, no fallback
        ),
      );

      return isAuthenticated;
    } on PlatformException catch (e) {
      debugPrint("Error during authentication: ${e.message}");
      return false;
    }
  }

  // Cancel an ongoing authentication
  Future<void> cancelAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      debugPrint("Error stopping authentication: $e");
    }
  }
}
