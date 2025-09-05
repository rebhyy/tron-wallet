part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

enum AddressDerivationType {
  bip32(CryptoKeyConst.accoutKeyIndex),
  substrate(CryptoKeyConst.substrateKeyIndex),
  multisig(CryptoKeyConst.multiSigAccountKeyIndex);

  final List<int> tag;
  const AddressDerivationType(this.tag);
  bool get isMultiSig => this == AddressDerivationType.multisig;

  static AddressDerivationType fromTag(List<int>? tag) {
    return values.firstWhere((e) => BytesUtils.bytesEqual(e.tag, tag),
        orElse: () => throw AppSerializationException(
            objectName: "AddressDerivationType"));
  }
}

abstract final class AddressDerivationIndex with CborSerializable, Equatable {
  const AddressDerivationIndex._();
  String? get hdPath;
  CryptoCoins get currencyCoin;
  AddressDerivationType get derivationType;
  String? get importedKeyId;
  int? get subId;
  bool get isImportedKey => importedKeyId != null;
  String get name;
  bool get isSubstrate => derivationType == AddressDerivationType.substrate;
  bool get isBip32 => derivationType == AddressDerivationType.bip32;
  bool get isMultiSig => derivationType.isMultiSig;

  /// change address index key (use imported key)
  AddressDerivationIndex asImportedKey(String importKeyId);

  AddressDerivationIndex asSubWalletKey(int subId);

  factory AddressDerivationIndex.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborTagValue cbor =
        CborSerializable.decode(cborBytes: bytes, object: obj);
    final key = AddressDerivationType.fromTag(cbor.tags);
    switch (key) {
      case AddressDerivationType.bip32:
        return Bip32AddressIndex.deserialize(obj: cbor);
      case AddressDerivationType.substrate:
        return SubstrateAddressIndex.deserialize(obj: cbor);
      case AddressDerivationType.multisig:
        return MultiSigAddressIndex();
    }
  }

  CryptoPrivateKeyData _derive(CryptoPrivateKeyData masterKey,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex});

  SeedTypes get seedGeneration;

  T cast<T extends AddressDerivationIndex>() {
    if (this is! T) {
      throw AppCryptoExceptionConst.internalError("AddressDerivationIndex");
    }
    return this as T;
  }
}
