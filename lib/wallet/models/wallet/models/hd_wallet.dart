import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/crypto/quick_crypto.dart';
import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/app/synchronized/basic_lock.dart';
import 'package:on_chain_wallet/app/utils/list/extension.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/types/credential.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';

final class HDWalletsConst {
  static const String initializeName = "Wallet";
  static const String firstWalletName = "$initializeName (1)";
  static const int checksumLength = 16;
  static const int defaultKeyIteration = 10;
}

final class HDWallets with CborSerializable {
  final _lock = SynchronizedLock();
  Map<String, MainWallet> _wallets;
  Map<String, MainWallet> get wallets => _wallets;
  String? _currentWallet;
  bool get hasWallet => _wallets.isNotEmpty;
  bool get needSetup => _wallets.isEmpty;

  List<String> get walletNames => _wallets.values.map((e) => e.name).toList();

  factory HDWallets.init() => HDWallets._(wallets: {});

  HDWallets._({required Map<String, MainWallet> wallets, String? currentWallet})
      : _wallets = Map<String, MainWallet>.unmodifiable(wallets),
        _currentWallet = wallets.containsKey(currentWallet)
            ? currentWallet
            : wallets.isEmpty
                ? null
                : wallets.keys.first;

  factory HDWallets.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.wallets);
    final wallets = values
        .elementAsListOf<CborTagValue>(0)
        .map((e) => MainWallet.deserialize(obj: e));
    return HDWallets._(
        wallets: Map<String, MainWallet>.fromEntries(
            wallets.map((e) => MapEntry<String, MainWallet>(e.key, e))),
        currentWallet: values.elementAs(1));
  }

  MainWallet _getInitializeWallet({String? key}) {
    if (_wallets.isEmpty) {
      throw WalletExceptionConst.incompleteWalletSetup;
    }
    if (_wallets.containsKey(key)) {
      return _wallets[key]!;
    }
    if (_wallets.containsKey(_currentWallet)) {
      return _wallets[_currentWallet]!;
    }
    final wallet = _wallets.values.first;
    return wallet;
  }

  Future<MainWallet> getInitializeWallet({String? key}) async {
    return _lock.synchronized(() async {
      final wallet = _getInitializeWallet(key: key);
      _currentWallet = wallet.key;
      return wallet;
    });
  }

  Future<void> removeWallet(MainWallet wallet) async {
    await _lock.synchronized(() async {
      if (_wallets.containsKey(wallet.key)) {
        final wallets = Map<String, MainWallet>.from(_wallets);
        wallets.remove(wallet.key);
        _wallets = Map<String, MainWallet>.unmodifiable(wallets);
        return;
      }
      throw WalletExceptionConst.walletDoesNotExists;
    });
  }

  Future<void> updateWallet(MainWallet wallet) async {
    await _lock.synchronized(() async {
      _wallets.values.firstWhere((element) => element.key == wallet.key,
          orElse: () => throw WalletExceptionConst.walletDoesNotExists);
      final wallets = Map<String, MainWallet>.from(_wallets);
      wallets[wallet.key] = wallet;
      _wallets = Map<String, MainWallet>.unmodifiable(wallets);
    });
  }

  Future<void> setupNewWallet(MainWallet newWallet) async {
    return _lock.synchronized(() async {
      final updateWallet = newWallet._updateCreated();
      if (updateWallet.data.isEmpty) {
        throw WalletExceptionConst.verificationWalletDataFailed;
      }
      if (updateWallet.key.trim().isEmpty || updateWallet.id.isNegative) {
        throw WalletExceptionConst.verificationWalletDataFailed;
      }
      final wallets = Map<String, MainWallet>.from(_wallets);
      if (wallets.values.any((element) =>
          element.key == updateWallet.key || element.id == updateWallet.id)) {
        throw WalletExceptionConst.verificationWalletDataFailed;
      }
      wallets[updateWallet.key] = updateWallet;
      _wallets = Map<String, MainWallet>.unmodifiable(wallets);
    });
  }

  String generateNewWalletChecksum() {
    String rand = BytesUtils.toHexString(
        QuickCrypto.generateRandom(HDWalletsConst.checksumLength));
    while (_wallets.containsKey("w_$rand")) {
      rand = BytesUtils.toHexString(
          QuickCrypto.generateRandom(HDWalletsConst.checksumLength));
    }
    return "w_$rand";
  }

  int generateNewWalletId() {
    int id = 0;
    while (_wallets.values.any((e) => e.id == id)) {
      id++;
    }
    return id;
  }

  MainWallet createNewMainWallet({
    required String name,
    bool protectWallet = true,
  }) {
    final key = generateNewWalletChecksum();
    final id = generateNewWalletId();
    return MainWallet._(
        key: key,
        name: name,
        data: '',
        requiredPassword: false,
        locktime: WalletLockTime.fiveMinute,
        network: 0,
        created: DateTime.now(),
        protectWallet: protectWallet,
        subWallets: const [],
        id: id,
        platformCredential: null);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborSerializable.fromDynamic(
              _wallets.values.map((e) => e._toCbor()).toList()),
          _currentWallet ?? const CborNullValue()
        ]),
        CborTagsConst.wallets);
  }
}

final class MainWallet {
  final int id;
  final String key;
  final String name;
  final String data;
  final bool requiredPassword;
  final bool protectWallet;
  final WalletLockTime locktime;
  final int network;
  final DateTime created;
  final List<SubWallet> subWallets;
  final WalletPlatformCredential? platformCredential;

  MainWallet.__({
    required this.id,
    required this.key,
    required this.name,
    required this.data,
    required this.requiredPassword,
    required this.locktime,
    required this.network,
    required this.created,
    required this.protectWallet,
    required List<SubWallet> subWallets,
    required this.platformCredential,
  })  : subWallets = subWallets.immutable,
        checkSumBytes = StringUtils.encode(key);

  factory MainWallet._({
    required String key,
    required String name,
    required String data,
    required bool requiredPassword,
    required WalletLockTime locktime,
    required int network,
    required int id,
    required WalletPlatformCredential? platformCredential,
    List<SubWallet> subWallets = const [],
    bool protectWallet = true,
    DateTime? created,
  }) {
    if (name.trim().isEmpty || name.length < 3 || name.length > 15) {
      throw WalletExceptionConst.invalidBackupOptions;
    }
    return MainWallet.__(
        key: key,
        name: name,
        data: data,
        requiredPassword: requiredPassword,
        locktime: locktime,
        network: network,
        created: created ?? DateTime.now(),
        protectWallet: protectWallet,
        subWallets: subWallets,
        id: id,
        platformCredential: platformCredential);
  }

  MainWallet updateData(String updateData) {
    return MainWallet._(
      key: key,
      name: name,
      data: updateData,
      requiredPassword: requiredPassword,
      network: network,
      locktime: locktime,
      created: created,
      protectWallet: protectWallet,
      subWallets: subWallets,
      id: id,
      platformCredential: platformCredential,
    );
  }

  MainWallet updateKey(String key) {
    if (this.key.isNotEmpty) throw WalletExceptionConst.invalidBackupOptions;
    return MainWallet._(
      key: key,
      name: name,
      data: data,
      requiredPassword: requiredPassword,
      network: network,
      locktime: locktime,
      created: created,
      protectWallet: protectWallet,
      subWallets: subWallets,
      id: id,
      platformCredential: platformCredential,
    );
  }

  MainWallet updateId(int id) {
    if (!this.id.isNegative) throw WalletExceptionConst.invalidBackupOptions;
    return MainWallet._(
      key: key,
      name: name,
      data: data,
      requiredPassword: requiredPassword,
      network: network,
      locktime: locktime,
      created: created,
      protectWallet: protectWallet,
      subWallets: subWallets,
      id: id,
      platformCredential: platformCredential,
    );
  }

  MainWallet updateNetwork(int updateNetworkId) {
    return MainWallet._(
      key: key,
      name: name,
      data: data,
      requiredPassword: requiredPassword,
      network: updateNetworkId,
      locktime: locktime,
      created: created,
      protectWallet: protectWallet,
      subWallets: subWallets,
      id: id,
      platformCredential: platformCredential,
    );
  }

  MainWallet _updateCreated() {
    return MainWallet._(
      key: key,
      name: name,
      data: data,
      requiredPassword: requiredPassword,
      network: network,
      locktime: locktime,
      created: DateTime.now(),
      protectWallet: protectWallet,
      subWallets: subWallets,
      id: id,
      platformCredential: platformCredential,
    );
  }

  MainWallet addNewSubWallet(
      {required SubWalletType type,
      required int subWalletId,
      required String data,
      required String name}) {
    if (subWallets.any((e) => e.id == subWalletId)) {
      throw WalletExceptionConst.walletAlreadyExists;
    }

    final sWallet = SubWallet.setup(id: subWalletId, name: name, type: type);
    return MainWallet._(
      key: key,
      name: name,
      data: data,
      requiredPassword: requiredPassword,
      network: network,
      locktime: locktime,
      created: created,
      protectWallet: protectWallet,
      subWallets: [sWallet, ...subWallets],
      id: id,
      platformCredential: platformCredential,
    );
  }

  MainWallet removeSubWallet(int subWalletId) {
    assert(
        subWallets.any((e) => e.id == subWalletId), "wallet does not exists.");

    return MainWallet._(
      key: key,
      name: name,
      data: data,
      requiredPassword: requiredPassword,
      network: network,
      locktime: locktime,
      created: created,
      protectWallet: protectWallet,
      subWallets: subWallets.where((e) => e.id != subWalletId).toList(),
      id: id,
      platformCredential: platformCredential,
    );
  }

  MainWallet updateSettings(
      {required WalletUpdateInfosData update, int? network}) {
    if (update.name.trim().isEmpty ||
        update.name.length < 3 ||
        update.name.length > 15) {
      throw WalletExceptionConst.invalidBackupOptions;
    }

    return MainWallet._(
      key: key,
      name: update.name,
      data: data,
      requiredPassword: update.requirmentPassword,
      network: network ?? this.network,
      locktime: update.lockTime,
      created: created,
      protectWallet: protectWallet,
      subWallets: subWallets,
      id: id,
      platformCredential: update.platformCredential,
    );
  }

  factory MainWallet.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.wallet);
    final int setting = values.valueAs(5);
    final int network = values.valueAs(4);
    WalletLockTime lockTime = WalletLockTime.fromValue(setting);
    return MainWallet._(
      key: values.valueAs(0),
      name: values.valueAs(1),
      data: values.valueAs(2),
      requiredPassword: values.valueAs(3),
      network: network,
      locktime: lockTime,
      created: values.valueAs<DateTime>(6),
      protectWallet: values.valueAs<bool?>(7) ?? true,
      subWallets: values
          .elementAsListOf<CborTagValue>(8)
          .map((e) => SubWallet.deserialize(obj: e))
          .toList(),
      id: values.elementAs(9),
      platformCredential:
          values.indexMaybeAs<WalletPlatformCredential, CborTagValue>(
              10, (e) => WalletPlatformCredential.deserialize(obj: e)),
    );
  }

  CborTagValue _toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          key,
          name,
          data,
          CborBoleanValue(requiredPassword),
          network,
          locktime.value,
          CborEpochIntValue(created),
          protectWallet,
          CborSerializable.fromDynamic(
              subWallets.map((e) => e.toCbor()).toList()),
          id,
          platformCredential?.toCbor()
        ]),
        CborTagsConst.wallet);
  }

  factory MainWallet.fromBackup({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.wallet);
    return MainWallet.__(
        id: -1,
        key: '',
        name: values.valueAs(0),
        data: '',
        requiredPassword: values.valueAs(1),
        locktime: WalletLockTime.fromValue(values.valueAs(3)),
        network: values.valueAs(2),
        created: values.valueAs(4),
        protectWallet: values.valueAs(5),
        subWallets: values
            .elementAsListOf<CborTagValue>(6)
            .map((e) => SubWallet.deserialize(obj: e))
            .toList(),
        platformCredential: null);
  }

  CborTagValue toBackup() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          name,
          CborBoleanValue(requiredPassword),
          network,
          locktime.value,
          CborEpochIntValue(created),
          protectWallet,
          CborSerializable.fromDynamic(
              subWallets.map((e) => e.toCbor()).toList()),
        ]),
        CborTagsConst.wallet);
  }

  final List<int> checkSumBytes;

  SubWallet? getSubWallet(int subId) {
    return subWallets.firstWhereOrNull((e) => e.id == subId);
  }
}

final class SubWallet with CborSerializable {
  final int id;
  final String name;
  final DateTime created;
  final SubWalletType walletType;

  const SubWallet._(
      {required this.id,
      required this.name,
      required this.created,
      required this.walletType});
  factory SubWallet(
      {required int id,
      required String name,
      required SubWalletType type,
      DateTime? created}) {
    if (name.trim().isEmpty || name.length < 3 || name.length > 15) {
      throw WalletExceptionConst.invalidBackupOptions;
    }
    return SubWallet._(
        id: id,
        walletType: type,
        name: name,
        created: created ?? DateTime.now());
  }
  factory SubWallet.setup(
      {required int id,
      required String name,
      required SubWalletType type,
      bool protectWallet = true}) {
    return SubWallet(id: id, name: name, created: DateTime.now(), type: type);
  }

  factory SubWallet.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.subWallet);
    return SubWallet(
        id: values.valueAs(0),
        name: values.valueAs(1),
        type: SubWalletType.fromValue(values.valueAs(2)),
        created: values.valueAs<DateTime>(3));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborIntValue(id),
          CborStringValue(name),
          CborBytesValue(walletType.tags),
          CborEpochIntValue(created),
        ]),
        CborTagsConst.subWallet);
  }
}

enum WalletLockTime {
  twoMinute(120, "two_minute"),
  fiveMinute(300, "five_minute"),
  tenMinute(600, "ten_minute"),
  thirtyMinute(1800, "thirty_minute");

  final int value;
  final String viewName;
  const WalletLockTime(this.value, this.viewName);
  static WalletLockTime fromValue(int value) {
    if (value == 0) {
      return WalletLockTime.fiveMinute;
    }
    return values.firstWhere((element) => element.value == value,
        orElse: () => WalletLockTime.fiveMinute);
  }
}

final class WalletUpdateInfosData {
  final String name;
  final WalletLockTime lockTime;
  final bool requirmentPassword;
  final bool protectWallet;
  final WalletPlatformCredential? platformCredential;
  const WalletUpdateInfosData(
      {required this.name,
      required this.lockTime,
      required this.requirmentPassword,
      required this.protectWallet,
      required this.platformCredential});
}
