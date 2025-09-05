import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

enum WalletCredentialType {
  login,
  verify,
  accountKey(allowPlatformCredential: false),
  importedKey(allowPlatformCredential: false),
  mnemonic(allowPlatformCredential: false),
  requirePassword(allowPlatformCredential: false);

  final bool allowPlatformCredential;
  const WalletCredentialType({this.allowPlatformCredential = true});
  bool get isLogin => this == login;
}

abstract final class WalletCredentialResponse {
  final WalletCredentialType type;
  WalletCredentialResponseVerify? get verificationId;
  const WalletCredentialResponse({required this.type});
  T cast<T extends WalletCredentialResponse>() {
    if (this is! T) {
      throw WalletExceptionConst.internalError("WalletCredentialResponse");
    }
    return this as T;
  }
}

final class WalletCredentialResponseLogin extends WalletCredentialResponse {
  const WalletCredentialResponseLogin._()
      : super(type: WalletCredentialType.login);
  static const WalletCredentialResponseLogin instance =
      WalletCredentialResponseLogin._();

  @override
  WalletCredentialResponseVerify? get verificationId => null;
}

final class WalletCredentialResponseMnemonic extends WalletCredentialResponse {
  final AccessMnemonicResponse credential;
  final WalletCredentialResponseVerify id;
  const WalletCredentialResponseMnemonic(
      {required this.credential, required this.id})
      : super(type: WalletCredentialType.mnemonic);

  @override
  WalletCredentialResponseVerify? get verificationId => id;
}

final class WalletCredentialResponseVerify extends WalletCredentialResponse {
  final String id;
  const WalletCredentialResponseVerify(this.id)
      : super(type: WalletCredentialType.verify);
  @override
  WalletCredentialResponseVerify? get verificationId => this;
}

final class WalletCredentialResponseRequirePassword
    extends WalletCredentialResponse {
  final WalletCredentialResponseVerify id;
  const WalletCredentialResponseRequirePassword({required this.id})
      : super(type: WalletCredentialType.requirePassword);
  @override
  WalletCredentialResponseVerify? get verificationId => id;
}

final class WalletCredentialResponseAccountKey
    extends WalletCredentialResponse {
  final List<CryptoPrivateKeyData> credentials;
  final WalletCredentialResponseVerify id;
  @override
  WalletCredentialResponseVerify? get verificationId => id;
  WalletCredentialResponseAccountKey(
      {required List<CryptoPrivateKeyData> credentials, required this.id})
      : credentials = credentials.immutable,
        super(type: WalletCredentialType.accountKey);
}

final class WalletCredentialResponseImportedKey
    extends WalletCredentialResponse {
  final CryptoPrivateKeyData credential;
  final WalletCredentialResponseVerify id;
  @override
  WalletCredentialResponseVerify? get verificationId => id;
  WalletCredentialResponseImportedKey(
      {required this.credential, required this.id})
      : super(type: WalletCredentialType.importedKey);
}

abstract final class WalletCredential<
    RESPONSE extends WalletCredentialResponse> {
  final WalletCredentialType type;
  const WalletCredential({required this.type});

  T cast<T extends WalletCredential>() {
    if (this is! T) {
      throw WalletExceptionConst.internalError("WalletCredential");
    }
    return this as T;
  }
}

final class WalletCredentialRequest<RESPONSE extends WalletCredentialResponse> {
  final WalletCredential<RESPONSE> credential;
  final String? password;
  final bool? platformCredential;
  const WalletCredentialRequest(
      {required this.credential, this.password, this.platformCredential});
  static const login =
      WalletCredentialRequest(credential: WalletCredentialLogin._());
}

final class WalletCredentialLogin
    extends WalletCredential<WalletCredentialResponseLogin> {
  const WalletCredentialLogin._() : super(type: WalletCredentialType.login);
  static const WalletCredentialLogin instance = WalletCredentialLogin._();
}

final class WalletCredentialAccountKey
    extends WalletCredential<WalletCredentialResponseAccountKey> {
  final ChainAccount account;
  const WalletCredentialAccountKey({required this.account})
      : super(type: WalletCredentialType.accountKey);
}

final class WalletCredentialImportedKey
    extends WalletCredential<WalletCredentialResponseImportedKey> {
  final String keyId;
  const WalletCredentialImportedKey({required this.keyId})
      : super(type: WalletCredentialType.importedKey);
}

final class WalletCredentialMnemonic
    extends WalletCredential<WalletCredentialResponseMnemonic> {
  const WalletCredentialMnemonic() : super(type: WalletCredentialType.mnemonic);
}

final class WalletCredentialRequirePassword
    extends WalletCredential<WalletCredentialResponseRequirePassword> {
  const WalletCredentialRequirePassword()
      : super(type: WalletCredentialType.requirePassword);
}

final class WalletCredentialVerify
    extends WalletCredential<WalletCredentialResponseVerify> {
  const WalletCredentialVerify() : super(type: WalletCredentialType.verify);
}

// final class CachedCredential {
//   final WalletCredentialResponseVerify credential;
//   final String? password;
//   const CachedCredential({required this.credential, required this.password});
// }
