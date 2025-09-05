import 'package:on_chain_bridge/models/biometric/types.dart';
import 'package:on_chain_wallet/app/dev/logger.dart';
import 'package:on_chain_wallet/app/native_impl/core/core.dart';
import 'package:on_chain_wallet/crypto/types/credential.dart';

import 'cross_platform.dart'
    if (dart.library.js_interop) 'web.dart'
    if (dart.library.io) 'io.dart' as c;

class PlatformCryptoMethods {
  static Future<WalletPlatformCredential?> createPlatformCredential({
    required String appName,
    required String name,
    required String displayName,
    required String accountId,
    String? title,
    String? buttonTitle,
    required String reason,
  }) {
    return c.createPlatformCredential(
        appName: name,
        accountId: accountId,
        displayName: displayName,
        name: name,
        reason: reason,
        buttonTitle: buttonTitle,
        title: title);
  }

  static Future<TouchIdStatus> touchIdStatus() {
    return AppNativeMethods.platform.touchIdStatus();
  }

  static Future<bool> supportPlatformCredential() async {
    try {
      final status = await touchIdStatus();
      return status == TouchIdStatus.available;
    } catch (e) {
      appLogger.error(
          runtime: "PlatformCryptoMethods",
          functionName: "supportPlatformCredential",
          msg: "check platform credential failed: $e");
      return false;
    }
  }

  static Future<BiometricResult> authenticate({
    required WalletPlatformCredential credential,
    required String reason,
    String? title,
    String? buttonTitle,
  }) {
    return c.authenticate(
        credential: credential,
        reason: reason,
        title: title,
        buttonTitle: buttonTitle);
  }
}
