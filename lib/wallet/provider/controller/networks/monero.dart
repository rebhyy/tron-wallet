part of 'package:on_chain_wallet/wallet/provider/wallet_provider.dart';

mixin WalletMoneroImpl on WalletManager {
  StreamSubscription<ChainEvent>? _listener;
  final _moneeroSyncLocker = SynchronizedLock();

  void _onMoneroNetworkEvent(MoneroChain chain, ChainEvent notify) {
    final type = notify.type;
    if (type != DefaultChainNotify.config) return;
    if (hasWalletKey) {
      chain.init().then((_) => _moneroUpdatePendingTxes(account: chain.cast()));
    }
  }

  void _listenOnMoneroNetwork() {
    _closeListener();
    final chain = _appChains.chain;
    if (chain.network.type == NetworkType.monero) {
      _listener = chain.stream
          .listen((event) => _onMoneroNetworkEvent(chain.cast(), event));
      if (hasWalletKey) {
        chain
            .init()
            .then((_) => _moneroUpdatePendingTxes(account: chain.cast()));
      }
    }
  }

  /// import monero pending transactions to account
  /// -[account]: related monero account.
  /// -[txIds]: transaction ids for importing.
  Future<List<MoneroUnlockedPaymentRequestDetails>> _moneroUpdatePendingTxes(
      {required MoneroChain account,
      List<MoneroAccountPendingTxes>? txIds}) async {
    return _moneeroSyncLocker.synchronized(() async {
      final txids = txIds ?? account.getAccountsPendingTxes();
      if (txids.isEmpty) return [];
      final client = await account.client();
      final r = await _callWalletInternal(
        (WalletInMemoryData masterKey, List<int> memoryKey) async {
          final unlockedInfo = await crypto.walletArgs(
              masterKey: masterKey,
              message: WalletRequestMoneroOutputUnlocker(
                  requests: txids, provider: client.service.provider),
              memoryKey: memoryKey);
          await account.addUnlockedPayment(unlockedInfo.payments);
          return WalletInternalCallResponse(result: unlockedInfo.payments);
        },
      ).catchError((e) => <MoneroAccountPendingTxes>[]);
      return r.map((e) => e.responses).expand((e) => e).toList();
    });
  }

  @override
  Future<bool> _switchNetwork(Chain network) async {
    final change = await super._switchNetwork(network);
    if (change) {
      _listenOnMoneroNetwork();
    }
    return change;
  }

  @override
  void _onUnlock() {
    super._onUnlock();
    final chains = _appChains.chains().whereType<MoneroChain>();
    for (final i in chains) {
      i.init().then((_) => _moneroUpdatePendingTxes(account: i));
    }
  }

  void _closeListener() {
    _listener?.cancel();
    _listener = null;
  }

  @override
  Future<void> _onInitController() async {
    await super._onInitController();
    _listenOnMoneroNetwork();
  }
}
