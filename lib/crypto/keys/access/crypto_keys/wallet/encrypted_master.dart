part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

final class EncryptedMasterKey with CborSerializable {
  final WalletInMemoryData masterKey;
  final List<int> storageData;

  String storageDataB64() {
    return StringUtils.decode(storageData, type: StringEncoding.base64);
  }

  ///  StringUtils.decode(result.keyTwo, type: StringEncoding.base64)
  final List<EncryptedCustomKey> customKeys;
  final List<EncryptedSubWallet> subWallets;
  EncryptedMasterKey.__({
    required this.masterKey,
    required List<EncryptedCustomKey> customKeys,
    required List<int> storageData,
    List<EncryptedSubWallet> subWallets = const [],
  })  : customKeys = customKeys.immutable,
        subWallets = subWallets.toImutableList,
        storageData = storageData.asImmutableBytes;
  factory EncryptedMasterKey._(
      {required WalletInMemoryData masterKey,
      required List<int> storageData,
      required List<EncryptedCustomKey> customKeys,
      required List<EncryptedSubWallet> subWallets}) {
    return EncryptedMasterKey.__(
        masterKey: masterKey,
        customKeys: customKeys,
        subWallets: subWallets,
        storageData: storageData);
  }
  factory EncryptedMasterKey.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CryptoKeyConst.encryptedMasterKey);
    final List<EncryptedCustomKey> customKeys = values
        .elementAsListOf<CborTagValue>(1)
        .map((e) => EncryptedCustomKey.deserialize(obj: e))
        .toList();
    final List<EncryptedSubWallet> subWallets = values
        .elementAsListOf<CborTagValue>(2, emyptyOnNull: true)
        .map((e) => EncryptedSubWallet.deserialize(obj: e))
        .toList();
    return EncryptedMasterKey._(
        masterKey: WalletInMemoryData.deserialize(
            obj: values.indexAs<CborTagValue>(0)),
        customKeys: customKeys,
        subWallets: subWallets,
        storageData: values.valueAs(3));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          masterKey.toCbor(),
          CborListValue.definite(customKeys.map((e) => e.toCbor()).toList()),
          CborListValue.definite(subWallets.map((e) => e.toCbor()).toList()),
          CborBytesValue(storageData)
        ]),
        CryptoKeyConst.encryptedMasterKey);
  }
}

final class EncryptedSubWallet with CborSerializable {
  final int id;
  final SubWalletType type;
  const EncryptedSubWallet._({required this.id, required this.type});
  factory EncryptedSubWallet.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CryptoKeyConst.encryptedSubWallet);
    return EncryptedSubWallet._(
        id: values.valueAs(0),
        type: SubWalletType.fromValue(values.valueAs(1)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite(
            [CborIntValue(id), CborBytesValue(type.tags)]),
        CryptoKeyConst.encryptedSubWallet);
  }
}
