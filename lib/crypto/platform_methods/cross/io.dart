import 'package:on_chain_bridge/io/io_platforms.dart';
import 'package:on_chain_bridge/models/biometric/types.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/native_impl/core/core.dart';
import 'package:on_chain_wallet/crypto/types/credential.dart';

Future<WalletPlatformCredentialIo?> createPlatformCredential({
  required String appName,
  required String name,
  required String displayName,
  required String accountId,
  String? title,
  String? buttonTitle,
  required String reason,
}) async {
  final credential = await AppNativeMethods.platform.createPlatformCredential(
      PlatformCredentialRequest(
          name: name,
          appName: appName,
          displayName: displayName,
          accountId: accountId.codeUnits,
          reason: reason));
  if (credential == null) return null;
  return WalletPlatformCredentialIo();
}

Future<BiometricResult> authenticate(
    {required WalletPlatformCredential credential,
    required String reason,
    String? title,
    String? buttonTitle}) async {
  if (credential.type != WalletPlatformCredentialType.localAuth) {
    throw AppCryptoExceptionConst.internalError("Authenticate");
  }
  final webCredential = AppNativeMethods.platform as IoPlatformInterface;

  return await webCredential.authenticate(
      PlatformCredentialAutneticateIoRequest(
          reason: reason, title: title, buttonTitle: buttonTitle));
}
