import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/crypto/keys/keys.dart';

final class CryptoGenerateMasterKeyResponse {
  final EncryptedMasterKey masterKey;
  CryptoGenerateMasterKeyResponse({
    required this.masterKey,
  });
}

final class CryptoRestoreBackupMasterKeyResponse {
  final EncryptedMasterKey encryptedKey;
  final WalletMasterKeys masterKey;
  final List<int>? checksum;
  final bool isValid;
  CryptoRestoreBackupMasterKeyResponse({
    required this.encryptedKey,
    required this.masterKey,
    required this.isValid,
    required List<int>? checksum,
  }) : checksum = checksum?.asImmutableBytes;
}

final class CryptoImportSubWalletResponse {
  final EncryptedMasterKey masterKey;

  final int subWalletId;
  CryptoImportSubWalletResponse({
    required this.masterKey,
    required this.subWalletId,
  });
}
