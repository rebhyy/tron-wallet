import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/crypto/quick_crypto.dart';
import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/app/synchronized/basic_lock.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/models/setting/models/lock_time.dart';

final class HDWalletsConst {
  static const String initializeName = "Wallet";
  static const String firstWalletName = "$initializeName (1)";
  static const int checksumLength = 16;
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

  Future<void> setupNewWallet(
    MainWallet newWallet,
  ) async {
    return _lock.synchronized(() async {
      final updateWallet = newWallet._updateCreated();
      if (updateWallet.data.isEmpty) {
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

  String _generateNewChecksum() {
    String rand = BytesUtils.toHexString(
        QuickCrypto.generateRandom(HDWalletsConst.checksumLength));
    while (_wallets.containsKey("w_$rand")) {
      rand = BytesUtils.toHexString(
          QuickCrypto.generateRandom(HDWalletsConst.checksumLength));
    }
    return "w_$rand";
  }

  int _generateNewWalletId() {
    int id = 0;
    while (_wallets.values.any((e) => e.id == id)) {
      id++;
    }
    return id;
  }

  MainWallet createNewMainWallet(
      {required String name, bool protectWallet = true}) {
    final key = _generateNewChecksum();
    final id = _generateNewWalletId();
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
        id: id);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue.fixedLength([
          CborListValue.fixedLength(
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
    List<SubWallet> subWallets = const [],
    bool protectWallet = true,
    DateTime? created,
  }) {
    if (name.trim().isEmpty || name.length < 3 || name.length > 15) {
      throw WalletExceptionConst.dataVerificationFailed;
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
        id: id);
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
        id: id);
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
        id: id);
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
        id: id);
  }

  MainWallet updateSettings({
    required WalletLockTime newLockTime,
    required bool reqPassword,
    required String newName,
    required bool protectWallet,
    int? network,
  }) {
    if (newName.trim().isEmpty || newName.length < 3 || newName.length > 15) {
      throw WalletExceptionConst.dataVerificationFailed;
    }

    return MainWallet._(
        key: key,
        name: newName,
        data: data,
        requiredPassword: reqPassword,
        network: network ?? this.network,
        locktime: newLockTime,
        created: created,
        protectWallet: protectWallet,
        subWallets: subWallets,
        id: id);
  }

  factory MainWallet.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values =
        CborSerializable.decodeCborTags(bytes, obj, CborTagsConst.wallet);
    final int setting = values.elementAs(5);
    final int network = values.elementAt(4);
    WalletLockTime lockTime = WalletLockTime.fromValue(setting);
    return MainWallet._(
        key: values.elementAs(0),
        name: values.elementAs(1),
        data: values.elementAs(2),
        requiredPassword: values.elementAs(3),
        network: network,
        locktime: lockTime,
        created: values.elementAs<DateTime>(6),
        protectWallet: values.elementAs<bool?>(7) ?? true,
        subWallets: values
            .elementAsListOf<CborTagValue>(8)
            .map((e) => SubWallet.deserialize(obj: e))
            .toList(),
        id: values.elementAs(9));
  }

  CborTagValue _toCbor() {
    return CborTagValue(
        CborListValue.fixedLength([
          key,
          name,
          data,
          CborBoleanValue(requiredPassword),
          network,
          locktime.value,
          CborEpochIntValue(created),
          protectWallet,
          CborListValue.fixedLength(subWallets.map((e) => e.toCbor()).toList()),
          id
        ]),
        CborTagsConst.wallet);
  }

  final List<int> checkSumBytes;
}

enum SubWalletType {
  bip39(0);

  final int value;
  const SubWalletType(this.value);
  static SubWalletType fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw WalletExceptionConst.invalidData(
          messsage: "Invalid sub wallet tag."),
    );
  }
}

final class SubWallet with CborSerializable {
  final String id;
  final String name;
  final String data;
  final DateTime created;
  final SubWalletType walletType;

  const SubWallet._(
      {required this.id,
      required this.name,
      required this.created,
      required this.walletType,
      required this.data});
  factory SubWallet({
    required String key,
    required String name,
    required SubWalletType type,
    required String data,
    DateTime? created,
  }) {
    if (name.trim().isEmpty || name.length < 3 || name.length > 15) {
      throw WalletExceptionConst.dataVerificationFailed;
    }
    return SubWallet._(
        id: key,
        walletType: type,
        name: name,
        created: created ?? DateTime.now(),
        data: data);
  }
  factory SubWallet.setup(
      {required String key,
      required String name,
      required SubWalletType type,
      required String data,
      bool protectWallet = true}) {
    return SubWallet(
        key: key, name: name, created: DateTime.now(), type: type, data: data);
  }

  factory SubWallet.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.subWallet);
    return SubWallet(
        key: values.elementAt(0),
        name: values.elementAt(1),
        type: SubWalletType.fromValue(values.elementAs<int>(2)),
        created: values.elementAt<DateTime>(3),
        data: values.elementAs(4));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue.fixedLength(
            [id, name, walletType.value, CborEpochIntValue(created), data]),
        CborTagsConst.subWallet);
  }
}
