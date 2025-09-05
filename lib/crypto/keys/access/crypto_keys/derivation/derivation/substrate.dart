part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

final class SubstrateAddressIndex extends AddressDerivationIndex {
  @override
  final String? importedKeyId;
  final String? keyName;
  final String? substratePath;

  @override
  String? get hdPath => substratePath;

  @override
  final SeedTypes seedGeneration;

  @override
  final SubstrateCoins currencyCoin;

  SubstrateAddressIndex._(
      {required this.currencyCoin,
      this.subId,
      this.importedKeyId,
      this.keyName,
      required this.substratePath})
      : seedGeneration = SeedTypes.bip39Entropy,
        super._();

  factory SubstrateAddressIndex.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CryptoKeyConst.substrateKeyIndex);
    return SubstrateAddressIndex._(
        currencyCoin: CustomCoins.getSerializationCoin(values.valueAs(0)),
        substratePath: values.valueAs(1),
        importedKeyId: values.valueAs(2),
        keyName: values.valueAs(3),
        subId: values.valueAs(4));
  }
  factory SubstrateAddressIndex(
      {required SubstrateCoins currencyCoin,
      String? substratePath,
      String? keyName}) {
    if (currencyCoin.proposal != SubstratePropoosal.substrate) {
      throw AppCryptoExceptionConst.invalidCoin;
    }
    if (substratePath != null) {
      final path = SubstratePathParser.parse(substratePath);
      substratePath = path.elems.isEmpty ? null : path.toStr();
    }

    return SubstrateAddressIndex._(
        currencyCoin: currencyCoin,
        keyName: keyName,
        substratePath: substratePath,
        subId: null);
  }

  factory SubstrateAddressIndex.fromPath(
      {required String substratePath, required SubstrateCoins currencyCoin}) {
    return SubstrateAddressIndex(
        currencyCoin: currencyCoin,
        keyName: null,
        substratePath: substratePath);
  }

  @override
  AddressDerivationIndex asImportedKey(String importKeyId) {
    if (subId != null) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    return SubstrateAddressIndex._(
        currencyCoin: currencyCoin,
        importedKeyId: importKeyId,
        keyName: keyName,
        substratePath: substratePath,
        subId: subId);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          currencyCoin.toCbor(),
          hdPath ?? const CborNullValue(),
          importedKeyId,
          keyName,
          subId
        ]),
        CryptoKeyConst.substrateKeyIndex);
  }

  @override
  List get variabels =>
      [currencyCoin.conf.type, importedKeyId, substratePath, subId];

  @override
  String toString() {
    return hdPath ?? "non_derivation";
  }

  @override
  AddressDerivationType get derivationType {
    return AddressDerivationType.substrate;
  }

  @override
  String get name => keyName ?? "main_key";

  @override
  CryptoPrivateKeyData _derive(CryptoPrivateKeyData masterKey,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex}) {
    if (substratePath == null) return masterKey;
    final substrate =
        Substrate.fromPrivateKey(masterKey.privateKeyBytes(), currencyCoin);
    final derive = substrate.derivePath(substratePath!);
    return PrivateKeyData._(
        coin: masterKey.coin,
        keyName: masterKey.keyName,
        key: derive.priveKey.privKey);
  }

  @override
  final int? subId;

  @override
  SubstrateAddressIndex asSubWalletKey(int subId) {
    if (importedKeyId != null) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    return SubstrateAddressIndex._(
        currencyCoin: currencyCoin,
        importedKeyId: importedKeyId,
        keyName: keyName,
        substratePath: substratePath,
        subId: subId);
  }
}
