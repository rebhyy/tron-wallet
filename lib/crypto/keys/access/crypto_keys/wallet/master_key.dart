part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

class WalletMasterKeysConst {
  static const int keyVersion = 2;
}

final class WalletMasterKeys with CborSerializable {
  final List<int> _mnemonic;
  final List<int> _seed;
  final List<int> _entopySeed;
  final List<int> _cardanoLegacyByronSeed;
  final List<int> _cardanoIcarusSeed;
  final List<int> _checksum;
  final APPBip39Languages _language;
  final List<ImportedKeyStorage> _customKeys;
  final List<SubWalletMasterKeys> _subWallets;
  List<int> get checksum => _checksum;
  List<SubWalletMasterKeys> get sub => _subWallets;

  AccessMnemonicResponse mnemonic() {
    final encode = Bip39MnemonicEncoder(_language.language).encode(_mnemonic);
    return AccessMnemonicResponse._(
        mnemonic: encode,
        subWallets: _subWallets
            .map((e) => SubWalletMnemonicResponse._(
                subWalletId: e.id, mnemonic: e.mnemonic()))
            .toList());
  }

  WalletMasterKeys._({
    required List<int> mnemonic,
    required List<int> seedBytes,
    required List<ImportedKeyStorage> customKeys,
    required List<SubWalletMasterKeys> subWallets,
    required List<int> entropySeedBytes,
    required List<int> cardanoLegacyByronSeed,
    required List<int> cardanoIcarusSeed,
    required List<int> checksum,
    required APPBip39Languages language,
  })  : _seed = seedBytes.asImmutableBytes,
        _cardanoLegacyByronSeed = cardanoLegacyByronSeed.asImmutableBytes,
        _cardanoIcarusSeed = cardanoIcarusSeed.asImmutableBytes,
        _checksum = checksum.asImmutableBytes,
        _entopySeed = entropySeedBytes.asImmutableBytes,
        _mnemonic = mnemonic.asImmutableBytes,
        _customKeys = customKeys.immutable,
        _language = language,
        _subWallets = subWallets.immutable;
  List<int> _getSeed(SeedTypes type) {
    switch (type) {
      case SeedTypes.bip39:
        return _seed;
      case SeedTypes.bip39Entropy:
        return _entopySeed;
      case SeedTypes.icarus:
        return _cardanoIcarusSeed;
      default:
        return _cardanoLegacyByronSeed;
    }
  }

  WalletMasterKeys _addKey(List<ImportedKeyStorage> newKey) {
    return WalletMasterKeys._(
        mnemonic: _mnemonic,
        seedBytes: _seed,
        customKeys: List.unmodifiable([...newKey, ..._customKeys]),
        cardanoLegacyByronSeed: _cardanoLegacyByronSeed,
        cardanoIcarusSeed: _cardanoIcarusSeed,
        checksum: _checksum,
        entropySeedBytes: _entopySeed,
        language: _language,
        subWallets: _subWallets);
  }

  WalletMasterKeys removeKey(String keyId) {
    final accounts = _customKeys.where((element) => element.checksum != keyId);
    return WalletMasterKeys._(
        mnemonic: _mnemonic,
        seedBytes: _seed,
        customKeys: List.unmodifiable(accounts),
        cardanoLegacyByronSeed: _cardanoLegacyByronSeed,
        cardanoIcarusSeed: _cardanoIcarusSeed,
        checksum: _checksum,
        entropySeedBytes: _entopySeed,
        language: _language,
        subWallets: _subWallets);
  }

  factory WalletMasterKeys.generate(
      {String? passphrase,
      required String mnemonic,
      List<SubWalletMasterKeys> subWallets = const []}) {
    final mn = Mnemonic.fromString(mnemonic);
    final language = APPBip39Languages.findLanguage(mn);

    final isValid = Bip39MnemonicValidator(language.language);
    if (!isValid.isValid(mnemonic)) {
      throw AppCryptoExceptionConst.invalidMnemonic;
    }
    final decode = Bip39MnemonicDecoder(language.language).decode(mn.toStr());
    final String passPhrase = passphrase ?? '';
    final seed = Bip39SeedGenerator(mn);
    final List<int> seedBytes = seed.generate(passPhrase);
    final List<int> entropySeedBytes = seed.generateFromEntropy(passPhrase);
    final icarus = CardanoIcarusSeedGenerator(mnemonic).generate();
    final cardanoLegacy = CardanoByronLegacySeedGenerator(mnemonic).generate();
    final List<int> checksum = QuickCrypto.sha3256Hash(
        [...seedBytes, ...icarus, ...cardanoLegacy, ...passPhrase.codeUnits]);

    return WalletMasterKeys._(
        mnemonic: decode,
        seedBytes: seedBytes,
        customKeys: List.unmodifiable([]),
        cardanoLegacyByronSeed: cardanoLegacy,
        cardanoIcarusSeed: icarus,
        checksum: checksum,
        entropySeedBytes: entropySeedBytes,
        language: language,
        subWallets: subWallets);
  }

  factory WalletMasterKeys.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    try {
      final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        hex: hex,
        tags: CryptoKeyConst.mnemonic,
      );

      final List<int> mnemonic = values.elementAs(0);
      final List<int> seed = values.elementAs(1);
      final importedKeys = values
          .elementAsListOf<CborTagValue>(2)
          .map((e) => ImportedKeyStorage.fromCborBytesOrObject(obj: e))
          .toList();
      final List<int> cardanoLegacy = values.elementAs(4);
      final List<int> icarus = values.elementAs(5);
      final List<int> checksum = values.elementAs(6);
      final List<int> entropySeed = values.elementAs(7);
      final APPBip39Languages language =
          APPBip39Languages.fromValue(values.elementAs(8));
      final subWallets = values
          .elementAsListOf<CborTagValue>(9, emyptyOnNull: true)
          .map((e) => SubWalletMasterKeys.deserialize(obj: e))
          .toList();
      return WalletMasterKeys._(
          mnemonic: mnemonic,
          seedBytes: seed,
          customKeys: importedKeys,
          cardanoLegacyByronSeed: cardanoLegacy,
          cardanoIcarusSeed: icarus,
          checksum: checksum,
          entropySeedBytes: entropySeed,
          language: language,
          subWallets: subWallets);
    } catch (e) {
      throw AppCryptoExceptionConst.invalidMnemonic;
    }
  }

  static (WalletMasterKeys, bool, List<int>?) generateFromBackup(
      {String? passphrase, List<int>? bytes, CborObject? obj, String? hex}) {
    try {
      final CborListValue values = CborSerializable.cborTagValue(
          cborBytes: bytes,
          object: obj,
          hex: hex,
          tags: CryptoKeyConst.backupMasterKey);

      final List<int> mnemonicBytes = values.elementAs(0);
      final importedKeys = values
          .elementAsListOf<CborTagValue>(1)
          .map((e) => ImportedKeyStorage.fromCborBytesOrObject(obj: e))
          .toList();
      final List<int> checksum = values.elementAs(2);
      final APPBip39Languages language =
          APPBip39Languages.fromValue(values.elementAs(3));
      final mnemonic =
          Bip39MnemonicEncoder(language.language).encode(mnemonicBytes);
      final subWallets = values
          .elementAsListOf<CborTagValue>(4, emyptyOnNull: true)
          .map((e) => SubWalletMasterKeys.deserialize(obj: e))
          .toList();
      final List<int>? backupChecksum = values.valueAs(5);
      WalletMasterKeys wallet = WalletMasterKeys.generate(
          mnemonic: mnemonic.toStr(),
          passphrase: passphrase,
          subWallets: subWallets);
      wallet = wallet._addKey(importedKeys);
      return (
        wallet,
        BytesUtils.bytesEqual(checksum, wallet.checksum),
        backupChecksum
      );
    } catch (e) {
      throw WalletExceptionConst.invalidBackup;
    }
  }

  @override
  CborTagValue toCbor({List<int>? backupChecksum}) {
    if (backupChecksum != null) {
      return CborTagValue(
          CborSerializable.fromDynamic([
            CborBytesValue(_mnemonic),
            CborSerializable.fromDynamic(
                _customKeys.map((e) => e.toCbor()).toList()),
            CborBytesValue(_checksum),
            _language.value,
            CborSerializable.fromDynamic(
                _subWallets.map((e) => e.toCbor()).toList()),
            CborBytesValue(backupChecksum)
          ]),
          CryptoKeyConst.backupMasterKey);
    }
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborBytesValue(_mnemonic),
          CborBytesValue(_seed),
          CborSerializable.fromDynamic(
              _customKeys.map((e) => e.toCbor()).toList()),
          const CborNullValue(),
          CborBytesValue(_cardanoLegacyByronSeed),
          CborBytesValue(_cardanoIcarusSeed),
          CborBytesValue(_checksum),
          CborBytesValue(_entopySeed),
          _language.value,
          CborSerializable.fromDynamic(
              _subWallets.map((e) => e.toCbor()).toList()),
        ]),
        CryptoKeyConst.mnemonic);
  }

  ImportedKeyStorage? getKeyById(String keyId) {
    return _customKeys.firstWhereOrNull((element) => element.checksum == keyId);
  }

  CryptoPrivateKeyData toKey(AddressDerivationIndex key,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex}) {
    if (key.isMultiSig) {
      throw AppCryptoExceptionConst.multiSigDerivationNotSuported;
    }
    if (key.isImportedKey) {
      final customKey = getKeyById(key.importedKeyId!);
      if (customKey == null) {
        throw AppCryptoExceptionConst.privateKeyIsNotAvailable;
      }
      return customKey.toKey(key, maxLevel: maxLevel);
    }

    if (key.subId != null) {
      final subKey = _subWallets.firstWhere((e) => e.id == key.subId,
          orElse: () => throw WalletExceptionConst.walletDoesNotExists);
      return subKey.toKey(key, maxLevel: maxLevel);
    }
    final seedBytes = _getSeed(key.seedGeneration);
    final bip32Key = CryptoPrivateKeyData._fromSeed(
        seedBytes: seedBytes, coin: key.currencyCoin, keyName: key.name);
    return key._derive(bip32Key, maxLevel: maxLevel);
  }

  CryptoPrivateKeysResponse readKeys(
      List<AccessCryptoPrivateKeyRequest> requestKeys) {
    final List<CryptoPrivateKeyData> keys = [];
    for (final i in requestKeys) {
      final key = toKey(i.index, maxLevel: Bip44Levels.fromInt(i.maxLevel));
      keys.add(key);
    }
    return CryptoPrivateKeysResponse._(keys);
  }

  CryptoPublicKeysResponse readPublicKeys(
      List<AccessCryptoPrivateKeyRequest> requestKeys) {
    final List<CryptoPublicKeyData> pubKeys = [];
    for (final i in requestKeys) {
      final bool byronLegacy =
          i.index.currencyCoin.proposal == CustomProposal.cip0019;
      final CryptoPrivateKeyData privateKey = toKey(i.index,
          maxLevel:
              byronLegacy ? Bip44Levels.master : Bip44Levels.addressIndex);
      if (!byronLegacy) {
        pubKeys.add(privateKey.publicKey);
        continue;
      }
      Bip32Base bipKey = privateKey.toBipKey();
      if (byronLegacy) {
        final legacy = CardanoByronLegacy.fromBip32(bipKey);
        if (i.index.hdPath != null) {
          bipKey = legacy.bip32.derivePath(i.index.hdPath!);
        }
        pubKeys.add(AdaLegacyPublicKeyData._fromBip32(
            account: bipKey,
            keyName: privateKey.keyName,
            hdPathKey: legacy.hdPathKey));
        continue;
      }
    }
    return CryptoPublicKeysResponse._(pubKeys);
  }

  CryptoPrivateKeyData getImportedKey(String keyId) {
    final importedKey = getKeyById(keyId);
    if (importedKey == null) {
      throw AppCryptoExceptionConst.privateKeyIsNotAvailable;
    }
    final keyInfo = importedKey.getKey();
    return keyInfo;
  }

  WalletMasterKeys importCustomKey(ImportedKeyStorage newKey,
      {bool validateChecksum = true}) {
    final ImportedKeyStorage validateKey;
    if (newKey.keyType == CustomKeyType.extendedKey) {
      validateKey = CryptoKeyUtils.extendeKeyToStorage(
          extendedKey: newKey.extendedPrivateKey, coin: newKey.coin);
    } else {
      validateKey = CryptoKeyUtils.privateKeyToStorage(
          privateKey: newKey.extendedPrivateKey, coin: newKey.coin);
    }

    if (validateKey.publicKey != newKey.publicKey) {
      throw WalletExceptionConst.invalidAccountDeta("importCustomKey");
    }
    if (validateChecksum && validateKey.checksum != newKey.checksum) {
      throw WalletExceptionConst.invalidAccountDeta("importCustomKey");
    }
    if (_customKeys.contains(newKey) ||
        _customKeys.any((e) => e.checksum == newKey.checksum)) {
      throw WalletExceptionConst.keyAlreadyExist;
    }
    return _addKey([newKey]);
  }

  EncryptedMasterKey encrypt(WalletInMemory key) {
    final storageBytes = _toStorage(key: key.key.key);
    final encryptedMasterKey = EncryptedMasterKey._(
        masterKey: WalletInMemoryData.generate_(
            key: key.key.key,
            walletData: toCbor().encode(),
            rawKey: key.key.rawKey,
            memoryKey: key.memoryKey),
        storageData: storageBytes,
        customKeys: _customKeys
            .map((e) => EncryptedCustomKey._(
                publicKey: e.publicKey,
                coin: e.coin,
                id: e.checksum,
                created: e.created,
                name: e.name,
                keyType: e.keyType))
            .toList(),
        subWallets: _subWallets
            .map((e) => EncryptedSubWallet._(id: e.id, type: e.type))
            .toList());
    return encryptedMasterKey;
  }

  EncryptedMasterKey encrypt_(
      {required List<int> key,
      required List<int> rawKey,
      required List<int> memoryKey}) {
    final storageBytes = _toStorage(key: key);
    final encryptedMasterKey = EncryptedMasterKey._(
        masterKey: WalletInMemoryData.generate_(
            key: key,
            walletData: toCbor().encode(),
            rawKey: rawKey,
            memoryKey: memoryKey),
        storageData: storageBytes,
        customKeys: _customKeys
            .map((e) => EncryptedCustomKey._(
                publicKey: e.publicKey,
                coin: e.coin,
                id: e.checksum,
                created: e.created,
                name: e.name,
                keyType: e.keyType))
            .toList(),
        subWallets: _subWallets
            .map((e) => EncryptedSubWallet._(id: e.id, type: e.type))
            .toList());
    return encryptedMasterKey;
  }

  List<int> _toStorage(
      {required List<int> key,
      int version = WalletMasterKeysConst.keyVersion}) {
    final List<int> nonce = WorkerCryptoUtils.generateNonce(key);
    final encrypt = WorkerCryptoUtils.encryptChacha(
        key: key, nonce: nonce, data: this.toCbor().encode());
    final toCbor = CborListValue<CborObject>.inDefinite(
        [CborIntValue(version), CborBytesValue(encrypt)]);
    return toCbor.encode();
  }

  (WalletMasterKeys, int) importNewSubWallet(
      {required String mnemonic,
      required SubWalletType type,
      String? passphrase}) {
    final SubWalletMasterKeys subWallet = switch (type) {
      SubWalletType.bip39 => Bip39WalletMasterKeys.generate(
          mnemonic: mnemonic, passphrase: passphrase),
      SubWalletType.monero => MoneroWalletMasterKeys.generate(mnemonic),
      SubWalletType.ton => TonWalletMasterKeys.generate(
          mnemonic: mnemonic, passphrase: passphrase),
    };
    if (_subWallets.any((e) => e.id == subWallet.id)) {
      throw WalletExceptionConst.walletAlreadyExists;
    }
    final masterKey = WalletMasterKeys._(
        mnemonic: _mnemonic,
        seedBytes: _seed,
        customKeys: _customKeys,
        cardanoLegacyByronSeed: _cardanoLegacyByronSeed,
        cardanoIcarusSeed: _cardanoIcarusSeed,
        checksum: _checksum,
        entropySeedBytes: _entopySeed,
        language: _language,
        subWallets: [..._subWallets, subWallet]);
    return (masterKey, subWallet.id);
  }

  WalletMasterKeys removeSubWallet(int id) {
    assert(_subWallets.any((e) => e.id == id), "wallet does not exists.");
    return WalletMasterKeys._(
        mnemonic: _mnemonic,
        seedBytes: _seed,
        customKeys: _customKeys,
        cardanoLegacyByronSeed: _cardanoLegacyByronSeed,
        cardanoIcarusSeed: _cardanoIcarusSeed,
        checksum: _checksum,
        entropySeedBytes: _entopySeed,
        language: _language,
        subWallets: _subWallets.where((e) => e.id != id).toList());
  }
}

class WalletInMemoryData with CborSerializable {
  final int version;
  final List<int> _nonce;
  final List<int> _data;
  final List<int> _key;

  factory WalletInMemoryData.generate_(
      {required List<int> key,
      required List<int> walletData,
      required List<int> rawKey,
      required List<int> memoryKey,
      int version = WalletMasterKeysConst.keyVersion}) {
    final password = WalletInMemoryKey(key: key, rawKey: rawKey);
    final List<int> nonce = QuickCrypto.generateRandom(12);
    final List<int> encrypt = WorkerCryptoUtils.encryptChacha(
        key: key, nonce: nonce, data: walletData);
    return WalletInMemoryData(
        version: version,
        nonce: nonce,
        data: encrypt,
        key: password._encrypt(memoryKey));
  }
  WalletInMemoryData(
      {required this.version,
      required List<int> nonce,
      required List<int> data,
      required List<int> key})
      : _nonce = nonce.asImmutableBytes,
        _data = data.asImmutableBytes,
        _key = key.asImmutableBytes;
  factory WalletInMemoryData.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: obj,
        tags: CryptoKeyConst.inMemoryKey);
    return WalletInMemoryData(
        version: values.valueAs(0),
        nonce: values.valueAs(1),
        data: values.valueAs(2),
        key: values.valueAs(3));
  }

  bool validateKey(List<int> key) {
    return BytesUtils.bytesEqual(key, _key);
  }

  WalletInMemoryKey _getMemoryKey(List<int> memoryKey) {
    try {
      final CborListValue values = CborSerializable.decode(cborBytes: _key);
      final List<int> nonce = values.valueAs(0);
      final List<int> encryptData = values.valueAs(1);
      final decrypt = WorkerCryptoUtils.decryptChacha(
          key: memoryKey, nonce: nonce, data: encryptData);
      return WalletInMemoryKey.deserialize(bytes: decrypt);
    } catch (e) {
      throw WalletExceptionConst.authFailed;
    }
  }

  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborIntValue(version),
          CborBytesValue(_nonce),
          CborBytesValue(_data),
          CborBytesValue(_key)
        ]),
        CryptoKeyConst.inMemoryKey);
  }
}

class WalletInMemoryKey with CborSerializable {
  final List<int> key;
  final List<int> rawKey;
  WalletInMemoryKey({required List<int> key, required List<int> rawKey})
      : key = key.asImmutableBytes,
        rawKey = rawKey.asImmutableBytes;
  factory WalletInMemoryKey.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: obj,
        tags: CryptoKeyConst.inMemoryPassword);
    return WalletInMemoryKey(key: values.valueAs(0), rawKey: values.valueAs(1));
  }
  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborBytesValue(key),
          CborBytesValue(rawKey),
        ]),
        CryptoKeyConst.inMemoryPassword);
  }

  List<int> _encrypt(List<int> key) {
    final nonce = QuickCrypto.generateRandom(12);
    final encrypt = WorkerCryptoUtils.encryptChacha(
        key: key, nonce: nonce, data: toCbor().encode());
    return CborListValue.definite([
      CborBytesValue(nonce),
      CborBytesValue(encrypt),
    ]).encode();
  }
}

class WalletInMemory {
  final WalletMasterKeys masterKey;
  final WalletInMemoryData data;
  final WalletInMemoryKey key;
  final List<int> memoryKey;
  WalletInMemory._(
      {required this.masterKey,
      required this.data,
      required this.key,
      required List<int> memoryKey})
      : memoryKey = memoryKey.asImmutableBytes;

  factory WalletInMemory.fromMemory(
      WalletInMemoryData key, List<int> memoryKey) {
    final k = key._getMemoryKey(memoryKey);
    final decrypt = WorkerCryptoUtils.decryptChacha(
        key: k.key, nonce: key._nonce, data: key._data);
    if (decrypt == null) {
      throw WalletExceptionConst.authFailed;
    }
    return WalletInMemory._(
        masterKey: WalletMasterKeys.deserialize(bytes: decrypt),
        data: key,
        key: k,
        memoryKey: memoryKey);
  }

  String get password => StringUtils.decode(key.rawKey);
}

enum SubWalletType {
  bip39([0, 0]),
  monero([1, 0]),
  ton([2, 0]);

  final List<int> tags;
  const SubWalletType(this.tags);
  static SubWalletType fromValue(List<int>? tags) {
    return values.firstWhere((e) => BytesUtils.bytesEqual(e.tags, tags),
        orElse: () =>
            throw AppSerializationException(objectName: "SubWalletType"));
  }
}

abstract class SubWalletMasterKeys with CborSerializable {
  // ignore: unused_field
  abstract final List<int> _checksum;
  abstract final int id;
  abstract final SubWalletType type;
  const SubWalletMasterKeys._();
  Mnemonic mnemonic();
  CryptoPrivateKeyData toKey(AddressDerivationIndex key,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex});
  factory SubWalletMasterKeys.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborTagValue decode =
        CborSerializable.decode(cborBytes: bytes, hex: hex, object: obj);
    final type = SubWalletType.fromValue(decode.tags);
    return switch (type) {
      SubWalletType.bip39 => Bip39WalletMasterKeys.deserialize(obj: decode),
      SubWalletType.monero => MoneroWalletMasterKeys.deserialize(obj: decode),
      SubWalletType.ton => TonWalletMasterKeys.deserialize(obj: decode)
    };
  }
}

final class Bip39WalletMasterKeys extends SubWalletMasterKeys {
  final List<int> _mnemonic;
  final List<int> _seed;
  final List<int> _entopySeed;
  final List<int> _cardanoLegacyByronSeed;
  final List<int> _cardanoIcarusSeed;
  @override
  final List<int> _checksum;
  final APPBip39Languages _language;
  @override
  final int id;
  List<int> get checksum => _checksum;

  @override
  Bip39Mnemonic mnemonic() {
    return Bip39MnemonicEncoder(_language.language).encode(_mnemonic);
  }

  factory Bip39WalletMasterKeys.generate(
      {String? passphrase, required String mnemonic}) {
    final mn = Mnemonic.fromString(mnemonic);
    final language = APPBip39Languages.findLanguage(mn);

    final isValid = Bip39MnemonicValidator(language.language);
    if (!isValid.isValid(mnemonic)) {
      throw AppCryptoExceptionConst.invalidMnemonic;
    }
    final decode = Bip39MnemonicDecoder(language.language).decode(mn.toStr());
    final String passPhrase = passphrase ?? '';
    final seed = Bip39SeedGenerator(mn);
    final List<int> seedBytes = seed.generate(passPhrase);
    final List<int> entropySeedBytes = seed.generateFromEntropy(passPhrase);
    final icarus = CardanoIcarusSeedGenerator(mnemonic).generate();
    final cardanoLegacy = CardanoByronLegacySeedGenerator(mnemonic).generate();
    final List<int> checksum =
        QuickCrypto.sha3256Hash([...seedBytes, ...icarus, ...cardanoLegacy]);
    final int id = Crc32.quickIntDigest(checksum);

    return Bip39WalletMasterKeys._(
        mnemonic: decode,
        seedBytes: seedBytes,
        cardanoLegacyByronSeed: cardanoLegacy,
        cardanoIcarusSeed: icarus,
        checksum: checksum,
        entropySeedBytes: entropySeedBytes,
        language: language,
        id: id);
  }

  Bip39WalletMasterKeys._({
    required List<int> mnemonic,
    required List<int> seedBytes,
    required List<int> entropySeedBytes,
    required List<int> cardanoLegacyByronSeed,
    required List<int> cardanoIcarusSeed,
    required List<int> checksum,
    required this.id,
    required APPBip39Languages language,
  })  : _seed = seedBytes.asImmutableBytes,
        _cardanoLegacyByronSeed = cardanoLegacyByronSeed.asImmutableBytes,
        _cardanoIcarusSeed = cardanoIcarusSeed.asImmutableBytes,
        _checksum = checksum.asImmutableBytes,
        _entopySeed = entropySeedBytes.asImmutableBytes,
        _mnemonic = mnemonic.asImmutableBytes,
        _language = language,
        super._();

  factory Bip39WalletMasterKeys.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        hex: hex,
        tags: SubWalletType.bip39.tags);
    return Bip39WalletMasterKeys._(
      mnemonic: values.valueAs(0),
      seedBytes: values.valueAs(1),
      entropySeedBytes: values.valueAs(2),
      cardanoLegacyByronSeed: values.valueAs(3),
      cardanoIcarusSeed: values.valueAs(4),
      checksum: values.valueAs(5),
      language: APPBip39Languages.fromValue(values.valueAs(6)),
      id: values.valueAs(7),
    );
  }

  @override
  CborTagValue toCbor({bool backup = false}) {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborBytesValue(_mnemonic),
          CborBytesValue(_seed),
          CborBytesValue(_entopySeed),
          CborBytesValue(_cardanoLegacyByronSeed),
          CborBytesValue(_cardanoIcarusSeed),
          CborBytesValue(_checksum),
          _language.value,
          id
        ]),
        type.tags);
  }

  @override
  SubWalletType get type => SubWalletType.bip39;

  List<int> _getSeed(SeedTypes type) {
    switch (type) {
      case SeedTypes.bip39:
        return _seed;
      case SeedTypes.bip39Entropy:
        return _entopySeed;
      case SeedTypes.icarus:
        return _cardanoIcarusSeed;
      default:
        return _cardanoLegacyByronSeed;
    }
  }

  @override
  CryptoPrivateKeyData toKey(AddressDerivationIndex key,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex}) {
    if (key.isMultiSig) {
      throw AppCryptoExceptionConst.multiSigDerivationNotSuported;
    }
    if (key.isImportedKey) {
      throw AppCryptoExceptionConst.privateKeyIsNotAvailable;
    }
    final seedBytes = _getSeed(key.seedGeneration);
    final bip32Key = CryptoPrivateKeyData._fromSeed(
        seedBytes: seedBytes, coin: key.currencyCoin, keyName: key.name);
    return key._derive(bip32Key, maxLevel: maxLevel);
  }
}

enum MoneroMnemonicType {
  checksum(0),
  nChecksum(1);

  const MoneroMnemonicType(this.value);

  final int value;
  static MoneroMnemonicType fromMnemonicLength(int length) {
    if (length == MoneroWordsNum.wordsNum13.value ||
        length == MoneroWordsNum.wordsNum25.value) {
      return MoneroMnemonicType.checksum;
    } else if (length == MoneroWordsNum.wordsNum12.value ||
        length == MoneroWordsNum.wordsNum24.value) {
      return MoneroMnemonicType.nChecksum;
    }
    throw AppCryptoExceptionConst.invalidMnemonic;
  }

  static MoneroMnemonicType fromValue(int? tag) {
    return values.firstWhere((e) => e.value == tag,
        orElse: () =>
            throw AppSerializationException(objectName: "MoneroMnemonicType"));
  }
}

final class MoneroWalletMasterKeys extends SubWalletMasterKeys {
  final List<int> _mnemonic;
  final List<int> _seed;
  @override
  final List<int> _checksum;
  final AppMoneroMnemonicLanguages _language;
  final MoneroMnemonicType _type;
  @override
  final int id;
  List<int> get checksum => _checksum;

  @override
  Mnemonic mnemonic() {
    switch (_type) {
      case MoneroMnemonicType.checksum:
        return MoneroMnemonicEncoder(_language.language)
            .encodeWithChecksum(_mnemonic);
      case MoneroMnemonicType.nChecksum:
        return MoneroMnemonicEncoder(_language.language)
            .encodeNoChecksum(_mnemonic);
    }
  }

  factory MoneroWalletMasterKeys.generate(String mnemonic) {
    final mn = Mnemonic.fromString(mnemonic);
    final language = AppMoneroMnemonicLanguages.findLanguage(mn);

    final isValid = MoneroMnemonicValidator(language.language);
    if (!isValid.isValid(mnemonic)) {
      throw AppCryptoExceptionConst.invalidMnemonic;
    }
    final decode = MoneroMnemonicDecoder(language.language).decode(mn.toStr());
    final seed = MoneroSeedGenerator(mn);
    final List<int> seedBytes = seed.generate();
    final List<int> checksum = QuickCrypto.sha3256Hash([...seedBytes]);
    final id = Crc32.quickIntDigest(checksum);
    return MoneroWalletMasterKeys._(
        mnemonic: decode,
        seedBytes: seedBytes,
        checksum: checksum,
        language: language,
        type: MoneroMnemonicType.fromMnemonicLength(mn.wordsCount()),
        id: id);
  }

  MoneroWalletMasterKeys._(
      {required List<int> mnemonic,
      required List<int> seedBytes,
      required List<int> checksum,
      required AppMoneroMnemonicLanguages language,
      required MoneroMnemonicType type,
      required this.id})
      : _seed = seedBytes.asImmutableBytes,
        _checksum = checksum.asImmutableBytes,
        _mnemonic = mnemonic.asImmutableBytes,
        _language = language,
        _type = type,
        super._();

  factory MoneroWalletMasterKeys.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        hex: hex,
        tags: SubWalletType.monero.tags);
    return MoneroWalletMasterKeys._(
        mnemonic: values.valueAs(0),
        seedBytes: values.valueAs(1),
        checksum: values.valueAs(2),
        language: AppMoneroMnemonicLanguages.fromValue(values.valueAs(3)),
        type: MoneroMnemonicType.fromValue(values.valueAs(4)),
        id: values.valueAs(5));
  }
  @override
  CborTagValue toCbor({bool backup = false}) {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborBytesValue(_mnemonic),
          CborBytesValue(_seed),
          CborBytesValue(_checksum),
          _language.value,
          _type.value,
          id
        ]),
        type.tags);
  }

  @override
  SubWalletType get type => SubWalletType.monero;

  @override
  CryptoPrivateKeyData toKey(AddressDerivationIndex key,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex}) {
    if (key is! Bip32AddressIndex) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    if (key.indexes.isNotEmpty) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    return MoneroPrivateKeyData._fromSeed(
        seedBytes: _seed, coin: key.currencyCoin, keyName: key.name);
  }
}

final class TonWalletMasterKeys extends SubWalletMasterKeys {
  final List<int> _mnemonic;
  final List<int> _seed;
  @override
  final int id;
  @override
  final List<int> _checksum;
  List<int> get checksum => _checksum;

  @override
  Mnemonic mnemonic() {
    return CryptoKeyUtils.bytesToBip39Mnemonic(
        bytes: _mnemonic, language: TonMnemonicLanguages.english);
  }

  factory TonWalletMasterKeys.generate(
      {required String mnemonic, required String? passphrase}) {
    final mn = Mnemonic.fromString(mnemonic);
    final seed = TonSeedGenerator(mn);
    final List<int> seedBytes =
        seed.generate(password: passphrase ?? '', validateTonMnemonic: true);
    final List<int> checksum = QuickCrypto.sha3256Hash([...seedBytes]);
    final int id = Crc32.quickIntDigest(checksum);
    return TonWalletMasterKeys._(
        mnemonic: CryptoKeyUtils.bip39MnemonicToBytes(mn),
        seedBytes: seedBytes,
        checksum: checksum,
        id: id);
  }

  TonWalletMasterKeys._(
      {required List<int> mnemonic,
      required List<int> seedBytes,
      required List<int> checksum,
      required this.id})
      : _seed = seedBytes.asImmutableBytes,
        _checksum = checksum.asImmutableBytes,
        _mnemonic = mnemonic.asImmutableBytes,
        super._();
  factory TonWalletMasterKeys.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, hex: hex, tags: SubWalletType.ton.tags);
    return TonWalletMasterKeys._(
        mnemonic: values.valueAs(0),
        seedBytes: values.valueAs(1),
        checksum: values.valueAs(2),
        id: values.valueAs(3));
  }

  @override
  CborTagValue toCbor({bool backup = false}) {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborBytesValue(_mnemonic),
          CborBytesValue(_seed),
          CborBytesValue(_checksum),
          CborIntValue(id)
        ]),
        type.tags);
  }

  @override
  SubWalletType get type => SubWalletType.ton;

  @override
  CryptoPrivateKeyData toKey(AddressDerivationIndex key,
      {Bip44Levels maxLevel = Bip44Levels.addressIndex}) {
    if (key is! Bip32AddressIndex) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    if (key.indexes.isNotEmpty) {
      throw AppCryptoExceptionConst.invalidDerivationKey;
    }
    return PrivateKeyData._(
        key: Ed25519PrivateKey.fromBytes(
            _seed.sublist(0, Ed25519KeysConst.privKeyByteLen)),
        coin: key.currencyCoin,
        keyName: key.name);
  }
}
