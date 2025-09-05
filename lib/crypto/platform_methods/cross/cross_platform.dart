import 'package:on_chain_bridge/models/biometric/types.dart';
import 'package:on_chain_wallet/crypto/types/credential.dart';

Future<WalletPlatformCredential?> createPlatformCredential({
  required String appName,
  required String name,
  required String displayName,
  required String accountId,
  String? title,
  String? buttonTitle,
  required String reason,
}) =>
    throw UnsupportedError(
        'Cannot create a instance without dart:js_interop or dart:io.');

Future<BiometricResult> authenticate({
  required WalletPlatformCredential credential,
  required String reason,
  String? title,
  String? buttonTitle,
}) =>
    throw UnsupportedError(
        'Cannot create a instance without dart:js_interop or dart:io.');
