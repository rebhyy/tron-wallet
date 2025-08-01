part of 'package:on_chain_wallet/wallet/models/chain/chain/chain.dart';

enum _WalletChainStatus {
  init,
  ready,
  dispose;

  bool get isInit => this == init;
}

enum _WalletAddressStatus {
  init,
  ready;

  bool get isInit => this == init;
}

abstract class ChainConfig<STORAGE extends ChainStorageKey>
    with CborSerializable, Equatable {
  double get appbarHeight => 0;
  bool get hasAction => false;
  List<STORAGE> get storageKeys;
  STORAGE? get tokenStorageKey;
  STORAGE? get nftStorageKey;
  STORAGE get transactionStorageKey;
  STORAGE get contactsStorageKey;
  List<STORAGE> get addressStorage;

  const ChainConfig();

  @override
  List get variabels => [storageKeys, hasAction];
}

abstract class ChainStorageKey {
  abstract final int storageId;
  bool get isSharedStorage;
}

/// maximum value 9999
enum AccountChainStorageKey implements ChainStorageKey {
  account(1000);

  /// account

  @override
  final int storageId;
  const AccountChainStorageKey(this.storageId);

  @override
  bool get isSharedStorage => false;
}

/// maximum value 999
enum DefaultChainStorageKey implements ChainStorageKey {
  contacts(0),
  transaction(1),
  token(2),
  nft(3);

  /// account

  @override
  final int storageId;
  const DefaultChainStorageKey(this.storageId);

  @override
  bool get isSharedStorage => false;
}

class DefaultChainConfig extends ChainConfig<DefaultChainStorageKey> {
  DefaultChainConfig();
  factory DefaultChainConfig.deserialize(
      {List<int>? bytess, CborObject? object, String? hex}) {
    return DefaultChainConfig();
  }

  @override
  DefaultChainStorageKey? get nftStorageKey => DefaultChainStorageKey.nft;

  @override
  DefaultChainStorageKey? get tokenStorageKey => DefaultChainStorageKey.token;

  @override
  DefaultChainStorageKey get transactionStorageKey =>
      DefaultChainStorageKey.transaction;
  @override
  DefaultChainStorageKey get contactsStorageKey =>
      DefaultChainStorageKey.contacts;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue.fixedLength([]), CborTagsConst.defaultChainConfig);
  }

  @override
  List<DefaultChainStorageKey> get storageKeys => DefaultChainStorageKey.values;

  @override
  List<DefaultChainStorageKey> get addressStorage => [
        DefaultChainStorageKey.transaction,
        DefaultChainStorageKey.token,
        DefaultChainStorageKey.nft
      ];
}

abstract final class BaseChain<
    PROVIDER extends APIProvider,
    NETWORKPARAMS extends NetworkCoinParams,
    NETWORKADDRESS,
    CHAINTOKEN extends TokenCore,
    NFT extends NFTCore,
    ADDRESS extends ChainAccount,
    NETWORK extends WalletNetwork,
    CLIENT extends NetworkClient,
    STORAGE extends ChainStorageKey,
    CONFIG extends ChainConfig,
    TRANSACTION extends ChainTransaction,
    CONTACT extends ContactCore,
    ADDRESSPARAM extends NewAccountParams> with CborSerializable {
  abstract _WalletChainStatus _status;
  abstract final NETWORK network;
  abstract final InternalStreamValue<IntegerBalance> totalBalance;
  abstract final String id;
  abstract CLIENT? _client;

  abstract List<ADDRESS> _addresses;
  abstract int _addressIndex;
  abstract final List<String> services;
  abstract List<CONTACT> _contacts;
  List<ADDRESS> get addresses => _addresses;
  bool get haveAddress => addresses.isNotEmpty;
  List<CONTACT> get contacts => _contacts;
  ADDRESS get address => addresses.elementAt(_addressIndex);
  abstract CONFIG _config;
  CONFIG get config => _config;
  abstract final SynchronizedLock _lock;

  abstract final ChainStorageManager _storage;

  abstract NodeClientStatus _clientStatus;
  NetworkServiceProtocol? get service => _client?.service;

  NodeClientStatus get serviceStatus => _clientStatus;

  ProviderIdentifier? get serviceIdentifier => _client?.serviceIdentifier;

  late final StreamController<ChainEvent> _controller =
      StreamController.broadcast();
  Stream<ChainEvent> get stream => _controller.stream;
  T cast<T extends Chain>() {
    if (this is! T) {
      throw WalletExceptionConst.invalidArgruments("$runtimeType", "$T");
    }
    return this as T;
  }
}

enum ChainNotify {
  address(0),
  account(1),
  client(2),
  config(3),
  contacts(4),
  transaction(5),
  token(6),
  nft(7);

  final int value;
  const ChainNotify(this.value);
  static ChainNotify fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw WalletExceptionConst.invalidData(
          messsage: 'Invalid chain notify tag'),
    );
  }
}

enum ChainNotifyStatus { progress, complete }

class ChainEvent {
  final ChainNotify type;
  final ChainNotifyStatus status;
  const ChainEvent({required this.type, required this.status});
  factory ChainEvent.progress(ChainNotify type) {
    return ChainEvent(type: type, status: ChainNotifyStatus.progress);
  }
  factory ChainEvent.complete(ChainNotify type) {
    return ChainEvent(type: type, status: ChainNotifyStatus.complete);
  }
}

enum ChainWalletEventType {
  ping,
  connection,
  chainChanged;
}

abstract final class ChainWalletEvent {
  final ChainWalletEventType type;
  const ChainWalletEvent({required this.type});
  T cast<T extends ChainWalletEvent>() {
    if (this is T) return this as T;
    throw WalletExceptionConst.invalidArgruments('$T', runtimeType.toString());
  }
}

final class ChainWalletPingEvent extends ChainWalletEvent {
  const ChainWalletPingEvent() : super(type: ChainWalletEventType.ping);
}

final class ChainWalletConnectionEvent extends ChainWalletEvent {
  final bool isOnline;
  const ChainWalletConnectionEvent(this.isOnline)
      : super(type: ChainWalletEventType.connection);
}

final class ChainWalletChainChangeEvent extends ChainWalletEvent {
  final Chain? prv;
  final Chain current;
  const ChainWalletChainChangeEvent({required this.prv, required this.current})
      : super(type: ChainWalletEventType.chainChanged);
}

typedef ONSTREAMVALUEDISPOSE = bool Function();

final class InternalStreamValue<T> implements StreamValue<T> {
  final bool _allowDispose;
  ONSTREAMVALUEDISPOSE? _disposeCallback;
  T _value;
  // InternalStreamValue(T val, {this.immutable = false}) : _value = val;
  InternalStreamValue.immutable(T val, {bool allowDispose = false})
      : _value = val,
        immutable = true,
        _allowDispose = allowDispose;
  @override
  final bool immutable;
  @override
  bool get isClosed => _controller.isClosed;

  late final StreamController<T> _controller =
      StreamController.broadcast(onCancel: () {}, onListen: () {});
  @override
  Stream<T> get stream => _controller.stream;

  @override
  T get value {
    return _value;
  }

  @override
  set silent(T newValue) {
    assert(!isClosed, 'stream  closed.');
    assert(!immutable, 'data marked as immutable');
    if (_value == newValue || immutable) return;
    _value = newValue;
  }

  @override
  set value(T newValue) {
    assert(!isClosed, 'stream  closed.');
    assert(!immutable, 'data marked as immutable');
    if (_value == newValue || immutable) return;
    _value = newValue;
    if (_controller.hasListener && !isClosed) {
      _controller.add(newValue);
    }
  }

  @override
  set updateValue(T newValue) {
    assert(!isClosed, 'stream  closed.');
    assert(!immutable, 'data marked as immutable');
    if (immutable) return;
    _value = newValue;
    if (_controller.hasListener && !isClosed) {
      _controller.add(newValue);
    }
  }

  @override
  void notify() {
    assert(!isClosed, 'stream  closed.');
    if (_controller.hasListener && !isClosed) {
      _controller.add(_value);
    }
  }

  void _disposeInternal() {
    assert(!isClosed, 'stream  closed.');
    _controller.close();
  }

  @override
  void dispose() {
    assert(_allowDispose, "dispose not allowed.");
    if (!_allowDispose) return;
    final callBack = _disposeCallback;
    if (callBack != null) {
      if (callBack()) {
        _disposeInternal();
      }
      return;
    }
    _disposeInternal();
  }
}
