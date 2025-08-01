part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

final class EncryptedMasterKey with CborSerializable {
  final List<int> masterKey;
  final List<EncryptedCustomKey> customKeys;
  final List<List<int>> subWallets;
  EncryptedMasterKey.__({
    required List<int> keyBytes,
    required List<EncryptedCustomKey> customKeys,
    List<List<int>> subWallets = const [],
  })  : masterKey = keyBytes.asImmutableBytes,
        customKeys = customKeys.immutable,
        subWallets = subWallets.map((e) => e.asImmutableBytes).toImutableList;
  factory EncryptedMasterKey._(
      {required List<int> keyBytes,
      required List<EncryptedCustomKey> customKeys,
      required List<List<int>> subWallets}) {
    return EncryptedMasterKey.__(
        keyBytes: keyBytes, customKeys: customKeys, subWallets: subWallets);
  }
  factory EncryptedMasterKey.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CryptoKeyConst.encryptedMasterKey);
    final List<EncryptedCustomKey> customKeys = values
        .elementAsListOf<CborTagValue>(1)
        .map((e) => EncryptedCustomKey.deserialize(obj: e))
        .toList();
    final List<List<int>> subWallets = values
        .elementAsListOf<CborBytesValue>(2, emyptyOnNull: true)
        .map((e) => e.value)
        .toList();
    return EncryptedMasterKey._(
        keyBytes: values.elementAs(0),
        customKeys: customKeys,
        subWallets: subWallets);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue.fixedLength([
          CborBytesValue(masterKey),
          CborListValue.fixedLength(customKeys.map((e) => e.toCbor()).toList()),
          CborListValue.fixedLength(
              subWallets.map((e) => CborBytesValue(e)).toList()),
        ]),
        CryptoKeyConst.encryptedMasterKey);
  }
}
