import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/messages/models/models/generate_master_key.dart';
import 'package:on_chain_wallet/crypto/utils/crypto/utils.dart';

class CryptoRequestRestoreBackupMasterKey extends CryptoRequest<
    CryptoRestoreBackupMasterKeyResponse, MessageArgsFourBytes> {
  final String? passphrase;
  final List<int> backup;
  final List<int> rawKey;
  final List<int> memoryKey;
  final List<int> checksum;
  CryptoRequestRestoreBackupMasterKey(
      {required this.passphrase,
      required List<int> backup,
      required List<int> rawKey,
      required List<int> memoryKey,
      required List<int> checksum})
      : backup = backup.asImmutableBytes,
        rawKey = rawKey.asImmutableBytes,
        memoryKey = memoryKey.asImmutableBytes,
        checksum = checksum.asImmutableBytes;

  factory CryptoRequestRestoreBackupMasterKey.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CryptoRequestMethod.createMasterKey.tag);
    return CryptoRequestRestoreBackupMasterKey(
        passphrase: values.valueAs(0),
        backup: values.valueAs(1),
        rawKey: values.valueAs(2),
        memoryKey: values.valueAs(3),
        checksum: values.valueAs(4));
  }

  @override
  MessageArgsFourBytes getResult() {
    final result = this.result();
    // final masterKey = WalletMasterKeys.generateFromBackup(
    //     passphrase: passphrase, bytes: backup);
    // final encrypt = masterKey.$1
    //     .encrypt_(key: rawKey, rawKey: rawKey, memoryKey: memoryKey);
    return MessageArgsFourBytes(
        keyOne: result.masterKey.toCbor().encode(),
        keyTwo: result.encryptedKey.toCbor().encode(),
        keyThree: [result.isValid ? 1 : 0],
        keyFour: result.checksum ?? []);
  }

  @override
  CryptoRestoreBackupMasterKeyResponse parsResult(MessageArgsFourBytes result) {
    return CryptoRestoreBackupMasterKeyResponse(
        masterKey: WalletMasterKeys.deserialize(bytes: result.keyOne),
        encryptedKey: EncryptedMasterKey.deserialize(bytes: result.keyTwo),
        isValid: result.keyThree[0] == 0 ? false : true,
        checksum: result.keyFour.emptyAsNull);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          passphrase,
          CborBytesValue(backup),
          CborBytesValue(rawKey),
          CborBytesValue(memoryKey),
          CborBytesValue(checksum)
        ]),
        method.tag);
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.createMasterKey;

  @override
  CryptoRestoreBackupMasterKeyResponse result() {
    final masterKey = WalletMasterKeys.generateFromBackup(
        passphrase: passphrase, bytes: backup);
    final key = WorkerCryptoUtils.hashKeyNew(key: rawKey, checksum: checksum);
    final encrypt =
        masterKey.$1.encrypt_(key: key, rawKey: rawKey, memoryKey: memoryKey);
    return CryptoRestoreBackupMasterKeyResponse(
        encryptedKey: encrypt,
        masterKey: masterKey.$1,
        isValid: masterKey.$2,
        checksum: masterKey.$3);
  }
}
