import 'package:blockchain_utils/crypto/quick_crypto.dart';
import 'package:blockchain_utils/utils/string/string.dart';
import 'package:on_chain_bridge/models/biometric/types.dart';
import 'package:on_chain_bridge/web/web.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/native_impl/core/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/types/credential.dart';
import 'package:on_chain_wallet/crypto/platform_methods/types/types.dart';

WebPlatformInterface get webPlatformInterface =>
    AppNativeMethods.platform as WebPlatformInterface;
Future<WalletPlatformCredentialWeb?> createPlatformCredential({
  required String appName,
  required String name,
  required String displayName,
  required String accountId,
  String? title,
  String? buttonTitle,
  required String reason,
}) async {
  final credential = await webPlatformInterface.createPlatformCredential(
      PlatformCredentialRequest(
          name: name,
          appName: appName,
          displayName: displayName,
          accountId: QuickCrypto.sha256Hash(StringUtils.encode(accountId)),
          reason: reason));
  if (credential == null) return null;
  final id = StringUtils.tryEncode(credential.id,
      allowUrlSafe: true,
      type: StringEncoding.base64UrlSafe,
      validateB64Padding: false);
  final pkBytes =
      CryptoKeyUtils.tryDecodeWebAuthPublicKeyCredential(credential.publicKey);
  if (id == null || pkBytes == null) {
    throw AppCryptoExceptionConst.invalidCredential;
  }
  return WalletPlatformCredentialWeb(id: id, publicKey: pkBytes);
}

Future<BiometricResult> authenticate(
    {required WalletPlatformCredential credential,
    required String reason,
    String? title,
    String? buttonTitle}) async {
  if (credential.type != WalletPlatformCredentialType.webAuth) {
    throw AppCryptoExceptionConst.internalError("Authenticate");
  }
  final webCredential = credential as WalletPlatformCredentialWeb;
  final request = AppPlatformCredentialAutneticateWebRequest(
    id: webCredential.id,
    reason: reason,
    challange: QuickCrypto.generateRandom(),
    pubKeyRawBytes: webCredential.publicKey,
    title: title,
    buttonTitle: buttonTitle,
  );
  return await webPlatformInterface.authenticate(request);
}
