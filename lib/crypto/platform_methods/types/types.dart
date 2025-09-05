import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_bridge/models/biometric/types.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

final class AppPlatformCredentialAutneticateWebRequest
    extends PlatformCredentialAutneticateWebRequest {
  final List<int> pubKeyRawBytes;
  AppPlatformCredentialAutneticateWebRequest(
      {required super.id,
      required super.reason,
      required super.challange,
      super.title,
      super.buttonTitle,
      required List<int> pubKeyRawBytes})
      : pubKeyRawBytes = pubKeyRawBytes.asImmutableBytes;

  @override
  Future<BiometricResult> verify(
      InternalPublicKeyWebAuthResponse response) async {
    final verify = CryptoKeyUtils.validateWebAuthSecp256p1DerSignature(
        authenticatorData: response.authenticatorData,
        clientDataJSON: response.clientDataJSON,
        signature: response.signature,
        pubKeyBytes: pubKeyRawBytes);
    assert(verify, "Invalid web auth signature");
    if (verify) return BiometricResult.success;
    return BiometricResult.failed;
  }
}
