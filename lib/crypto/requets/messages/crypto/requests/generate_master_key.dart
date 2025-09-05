import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';
import 'package:on_chain_wallet/crypto/utils/crypto/utils.dart';

class CryptoRequestGenerateMasterKey
    extends CryptoRequest<EncryptedMasterKey, MessageArgsOneBytes> {
  final List<int> walletData;
  final int version;
  final List<int>? newKeyString;
  final List<int> keyString;
  final List<int> keyChecksum;
  final List<int> memoryKey;
  CryptoRequestGenerateMasterKey._({
    required this.version,
    required List<int> walletData,
    required List<int> keyString,
    required List<int> keyChecksum,
    required List<int> memoryKey,
    List<int>? newKeyString,
  })  : walletData = walletData.asImmutableBytes,
        newKeyString = newKeyString?.asImmutableBytes,
        keyString = keyString.asImmutableBytes,
        keyChecksum = keyChecksum.asImmutableBytes,
        memoryKey = memoryKey.asImmutableBytes;
  factory CryptoRequestGenerateMasterKey.fromStorage(
      {required String storageData,
      required String key,
      String? newKey,
      required List<int> checksum,
      required List<int> memoryKey}) {
    try {
      final dataBytes = List<int>.unmodifiable(
          StringUtils.encode(storageData, type: StringEncoding.base64));
      final CborListValue values =
          CborSerializable.decode(cborBytes: dataBytes);
      return CryptoRequestGenerateMasterKey._(
          version: values.valueAs(0),
          walletData: values.valueAs(1),
          keyString: StringUtils.encode(key),
          newKeyString: newKey == null ? null : StringUtils.encode(newKey),
          keyChecksum: checksum,
          memoryKey: memoryKey);
    } catch (e) {
      throw WalletExceptionConst.incorrectWalletData;
    }
  }

  factory CryptoRequestGenerateMasterKey.fromStorageWithStringKey(
      {required String storageData,
      required String key,
      required List<int> checksum,
      required List<int> memoryKey,
      String? newKey}) {
    try {
      final CborListValue values = CborSerializable.decode(
          cborBytes:
              StringUtils.encode(storageData, type: StringEncoding.base64));
      return CryptoRequestGenerateMasterKey._(
          version: values.valueAs(0),
          walletData: values.valueAs(1),
          newKeyString: newKey == null ? null : StringUtils.encode(newKey),
          keyString: StringUtils.encode(key),
          keyChecksum: checksum,
          memoryKey: memoryKey);
    } catch (e) {
      throw WalletExceptionConst.incorrectWalletData;
    }
  }

  factory CryptoRequestGenerateMasterKey.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CryptoRequestMethod.generateMasterKey.tag);
    return CryptoRequestGenerateMasterKey._(
        version: values.valueAs(0),
        walletData: values.valueAs(1),
        newKeyString: values.valueAs(2),
        keyString: values.valueAs(3),
        keyChecksum: values.valueAs(4),
        memoryKey: values.valueAs(5));
  }

  /// encrypted master key, storage encrypted wallet
  static EncryptedMasterKey generateMasterKey(
      {required List<int> key,
      required List<int> walletData,
      required List<int>? newKey,
      required List<int> memoryKey,
      required List<int> rawKey}) {
    final nonce = WorkerCryptoUtils.generateNonce(key);
    final decrypt = WorkerCryptoUtils.decryptChacha(
        key: key, nonce: nonce, data: walletData);
    if (decrypt == null) {
      throw WalletExceptionConst.authFailed;
    }
    final masterKey = WalletMasterKeys.deserialize(bytes: decrypt);
    return masterKey.encrypt_(
        key: newKey ?? key, memoryKey: memoryKey, rawKey: rawKey);
  }

  @override
  MessageArgsOneBytes getResult() {
    return MessageArgsOneBytes(keyOne: result().toCbor().encode());
  }

  @override
  EncryptedMasterKey parsResult(MessageArgsOneBytes result) {
    return EncryptedMasterKey.deserialize(bytes: result.keyOne);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          version,
          CborBytesValue(walletData),
          newKeyString,
          CborBytesValue(keyString),
          CborBytesValue(keyChecksum),
          CborBytesValue(memoryKey),
        ]),
        method.tag);
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.generateMasterKey;

  @override
  EncryptedMasterKey result() {
    List<int>? walletKey;
    List<int>? newKey;
    if (version == 1) {
      walletKey =
          WorkerCryptoUtils.hashKeyOld(key: keyString, checksum: keyChecksum);
      assert(newKeyString == null);
      newKey =
          WorkerCryptoUtils.hashKeyNew(key: keyString, checksum: keyChecksum);
    } else {
      walletKey =
          WorkerCryptoUtils.hashKeyNew(key: keyString, checksum: keyChecksum);
    }
    if (newKeyString != null) {
      newKey = WorkerCryptoUtils.hashKeyNew(
          key: newKeyString!, checksum: keyChecksum);
    }
    return generateMasterKey(
        key: walletKey,
        walletData: walletData,
        newKey: newKey,
        memoryKey: memoryKey,
        rawKey: newKeyString ?? keyString);
  }
}
