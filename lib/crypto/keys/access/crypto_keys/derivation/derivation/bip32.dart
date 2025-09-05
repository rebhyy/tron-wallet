part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

final class Bip32AddressIndex extends AddressDerivationIndex {
  final int? purpose;
  final int? coin;
  final int? accountLevel;
  final int? changeLevel;
  final int? addressIndex;
  @override
  final String? importedKeyId;
  final String? keyName;

  @override
  final String? hdPath;

  @override
  final SeedTypes seedGeneration;
  @override
  final CryptoCoins currencyCoin;

  @override
  final int? subId;

  Bip32AddressIndex._({
    required this.purpose,
    required this.coin,
    required this.accountLevel,
    required this.changeLevel,
    required this.addressIndex,
    required this.currencyCoin,
    required this.seedGeneration,
    this.importedKeyId,
    this.keyName,
    this.subId,
  })  : hdPath = _toPath(
            [purpose, coin, accountLevel, changeLevel, addressIndex],
            importedKeyId: importedKeyId),
        super._();

  factory Bip32AddressIndex.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CryptoKeyConst.accoutKeyIndex);
    return Bip32AddressIndex._(
        purpose: values.valueAs(0),
        coin: values.valueAs(1),
        accountLevel: values.valueAs(2),
        changeLevel: values.valueAs(3),
        addressIndex: values.valueAs(4),
        currencyCoin: CustomCoins.getSerializationCoin(values.valueAs(5)),
        seedGeneration: SeedTypes.fromValue(values.valueAs(6)),
        importedKeyId: values.valueAs(7),
        keyName: values.valueAs(8),
        subId: values.valueAs(9));
  }
  factory Bip32AddressIndex.byronLegacy(
      {required int firstIndex,
      required int secoundIndex,
      required CryptoCoins currencyCoin,
      String? keyName}) {
    return Bip32AddressIndex._(
        purpose: firstIndex,
        coin: secoundIndex,
        accountLevel: null,
        changeLevel: null,
        addressIndex: null,
        currencyCoin: currencyCoin,
        seedGeneration: SeedTypes.byronLegacySeed,
        keyName: keyName);
  }

  factory Bip32AddressIndex(
      {int? purpose,
      int? coin,
      int? accountLevel,
      int? changeLevel,
      int? addressIndex,
      required CryptoCoins currencyCoin,
      required SeedTypes seedGeneration,
      String? keyName}) {
    if (currencyCoin.proposal == SubstratePropoosal.substrate ||
        currencyCoin.conf.type == EllipticCurveTypes.sr25519) {
      throw AppCryptoExceptionConst.invalidCoin;
    }
    return Bip32AddressIndex._(
        purpose: purpose,
        coin: coin,
        accountLevel: accountLevel,
        changeLevel: changeLevel,
        addressIndex: addressIndex,
        currencyCoin: currencyCoin,
        seedGeneration: seedGeneration,
        keyName: keyName);
  }

  Bip32AddressIndex copyWith(
      {int? purpose,
      int? coin,
      int? accountLevel,
      int? changeLevel,
      int? addressIndex,
      String? keyName}) {
    return Bip32AddressIndex._(
        purpose: purpose ?? this.purpose,
        coin: coin ?? this.coin,
        accountLevel: accountLevel ?? this.accountLevel,
        changeLevel: changeLevel ?? this.changeLevel,
        addressIndex: addressIndex ?? this.addressIndex,
        seedGeneration: seedGeneration,
        currencyCoin: currencyCoin,
        importedKeyId: importedKeyId,
        keyName: keyName ?? this.keyName,
        subId: subId);
  }

  factory Bip32AddressIndex.fromPath(
      {required String path,
      required CryptoCoins currencyCoin,
      required SeedTypes seedGeneration}) {
    final indexes = Bip32PathParser.parse(path).elems;
    if (indexes.length > 5) {
      throw AppCryptoException("unsupported_hd_wallet_index");
    }
    return Bip32AddressIndex(
        purpose: indexes.elementAtOrNull(0)?.index,
        coin: indexes.elementAtOrNull(1)?.index,
        accountLevel: indexes.elementAtOrNull(2)?.index,
        changeLevel: indexes.elementAtOrNull(3)?.index,
        addressIndex: indexes.elementAtOrNull(4)?.index,
        currencyCoin: currencyCoin,
        seedGeneration: seedGeneration,
        keyName: null);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          purpose,
          coin,
          accountLevel,
          changeLevel,
          addressIndex,
          currencyCoin.toCbor(),
          seedGeneration.value,
          importedKeyId,
          keyName,
          subId
        ]),
        CryptoKeyConst.accoutKeyIndex);
  }

  @override
  List get variabels => [
        purpose,
        coin,
        accountLevel,
        changeLevel,
        addressIndex,
        currencyCoin.conf.type,
        seedGeneration.name,
        importedKeyId,
        subId
      ];

  static String? _toPath(List<int?> indexses, {String? importedKeyId}) {
    if (indexses.isEmpty) return null;
    final bipIndexes = indexses
        .where((element) => element != null)
        .map((e) => Bip32KeyIndex(e!))
        .toList();
    if (bipIndexes.isEmpty) return null;
    String pathStr = "${Bip32PathConst.masterChar}/";
    for (final elem in bipIndexes) {
      if (!elem.isHardened) {
        pathStr += "${elem.toInt()}/";
      } else {
        pathStr += "${elem.unharden().toInt()}'/";
      }
    }
    return pathStr.substring(0, pathStr.length - 1);
  }

  @override
  CryptoPrivateKeyData _derive(CryptoPrivateKeyData masterKey,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex}) {
    if (maxLevel == Bip44Levels.master || indexes.isEmpty) {
      return masterKey;
    }
    final key = masterKey.toBipKey();
    List<Bip32KeyIndex> bip32KeyIndexes = indexes.immutable;
    final maxIndex = maxLevel.value;
    if (bip32KeyIndexes.length > maxIndex) {
      bip32KeyIndexes = bip32KeyIndexes.sublist(0, maxIndex).immutable;
    }
    Bip32Base deriveToIndex = key;
    for (final i in bip32KeyIndexes) {
      deriveToIndex = deriveToIndex.childKey(i);
    }
    return CryptoPrivateKeyData._fromBip32(
        account: deriveToIndex,
        coin: masterKey.coin,
        keyName: masterKey.keyName);
  }

  List<Bip32KeyIndex> get indexes =>
      <int?>[purpose, coin, accountLevel, changeLevel, addressIndex]
          .where((element) => element != null)
          .map((e) => Bip32KeyIndex(e!))
          .toList();

  @override
  String toString() {
    return hdPath ?? "non_derivation";
  }

  @override
  AddressDerivationType get derivationType {
    return AddressDerivationType.bip32;
  }

  @override
  String get name => keyName ?? "main_key";

  @override
  AddressDerivationIndex asImportedKey(String importKeyId) {
    if (subId != null) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    return Bip32AddressIndex._(
        purpose: purpose,
        coin: coin,
        accountLevel: accountLevel,
        changeLevel: changeLevel,
        addressIndex: addressIndex,
        currencyCoin: currencyCoin,
        seedGeneration: seedGeneration,
        subId: subId,
        importedKeyId: importKeyId,
        keyName: keyName);
  }

  @override
  Bip32AddressIndex asSubWalletKey(int subId) {
    if (importedKeyId != null) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    return Bip32AddressIndex._(
        purpose: purpose,
        coin: coin,
        accountLevel: accountLevel,
        changeLevel: changeLevel,
        addressIndex: addressIndex,
        currencyCoin: currencyCoin,
        seedGeneration: seedGeneration,
        subId: subId,
        importedKeyId: importedKeyId,
        keyName: keyName);
  }
}
