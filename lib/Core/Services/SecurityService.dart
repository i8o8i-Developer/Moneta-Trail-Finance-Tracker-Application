// Moneta Trail Security Service Manager
// Handles Biometric Authentication And Local PIN Secure Storage

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class SecurityService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _pinKey = 'user_pin_hash';

  // Checks If Device Supports Biometric Authentication
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canAuthenticateWithBiometrics && isDeviceSupported;
    } catch (e) {
      print('Failed To Check Biometric Availability: $e');
      return false;
    }
  }

  // Prompts User For Biometric Authentication
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate To Access Moneta Trail',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print('Biometric Authentication Error: $e');
      return false;
    }
  }

  // Saves Local PIN Hash Into Secure Storage
  Future<void> setPin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: pin);
  }

  // Verifies User Input PIN Against Saved Secure Storage
  Future<bool> verifyPin(String inputPin) async {
    final String? savedPin = await _secureStorage.read(key: _pinKey);
    if (savedPin == null) return true; // If No PIN Is Set, Return True
    return savedPin == inputPin;
  }

  // Clears Saved PIN Data
  Future<void> clearPin() async {
    await _secureStorage.delete(key: _pinKey);
  }
}
