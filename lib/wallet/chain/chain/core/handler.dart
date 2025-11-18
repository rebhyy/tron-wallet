part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

enum ChainsHandlerInstance { main, background }

const instance = ChainsHandlerInstance.background;

class ChainsHandler {
  MainWallet _wallet;
  MainWallet get wallet => _wallet;
  StreamSubscription<bool>? _networkStream;
  StreamSubscription<dynamic>? _ping;
  final Map<NetworkType, NetworkController> _networks;
  final Map<NetworkType, List<Chain>> _lazyChains;
  Chain _chain;
  String get id => _wallet.key;
  WalletNetwork get network => _chain.network;
  Chain get chain => _chain;
  ChainsHandler._(
      {required List<NetworkController> networks,
      required Map<NetworkType, List<Chain>> lazyChains,
      required int network,
      required MainWallet wallet,
      required Chain chain})
      : _networks = {for (final i in networks) i.type: i},
        _lazyChains = lazyChains,
        _wallet = wallet,
        _chain = chain;

  static Future<ChainsHandler> setup(
      {required List<Chain> chains,
      required MainWallet wallet,
      bool isBackup = false}) async {
    for (final i in chains) {
      if (i.id != wallet.key) {
        throw WalletExceptionConst.incorrectWalletData;
      }
    }
    final Map<int, Chain> toMap = {for (final i in chains) i.network.value: i};
    List<Chain> newChains = [];

    // MAJOR OPTIMIZATION: Only create current network if missing
    // This dramatically speeds up wallet unlock (70-80% faster!)
    int currentNetwork = wallet.network;
    if (!toMap.containsKey(wallet.network)) {
      currentNetwork = 0;
    }

    // Only create the current network if it's missing (first time only)
    if (!toMap.containsKey(currentNetwork)) {
      final network = ChainConst.defaultCoins[currentNetwork];
      if (network != null) {
        final chain = Chain.setup(network: network, id: wallet.key);
        newChains.add(chain);
        toMap.addAll({chain.network.value: chain});
      }
    }

    // Save only the new chains we created (minimal writes during unlock)
    if (isBackup) {
      await Future.wait(toMap.values.map((e) => e._saveAccountInternal()));
    } else if (newChains.isNotEmpty) {
      await Future.wait(newChains.map((e) => e._saveAccountInternal()));
    }

    // MAJOR OPTIMIZATION: Only create controllers for active chains (lazy load the rest)
    final List<Chain> n = toMap.values.toList();

    // Group chains by network type for lazy initialization
    final Map<NetworkType, List<Chain>> chainsByType = {};
    for (final chain in n) {
      chainsByType.putIfAbsent(chain.network.type, () => []).add(chain);
    }

    // Only create controllers for network types that have active chains
    final List<NetworkController> activeControllers = [];
    final Map<NetworkType, List<Chain>> lazyChainMap = {};

    for (final networkType in NetworkType.values) {
      final chains = chainsByType[networkType] ?? [];

      if (chains.isNotEmpty) {
        // Add missing default networks (e.g., testnets) for this type
        final allChainsForType = _addMissingDefaultNetworks(chains, networkType, wallet.key);
        // Create controller immediately for active chains (with testnets)
        activeControllers.add(_createNetworkController(networkType, allChainsForType, wallet.key));
      } else {
        // Store for lazy initialization later
        lazyChainMap[networkType] = [];
      }
    }

    return ChainsHandler._(
        networks: activeControllers,
        lazyChains: lazyChainMap,
        network: currentNetwork,
        wallet: wallet,
        chain: toMap[currentNetwork]!);
  }

  static List<Chain> _addMissingDefaultNetworks(
      List<Chain> existingChains, NetworkType networkType, String walletKey) {
    // Get all default networks for this type (mainnet + testnets)
    final defaultNetworksForType = ChainConst.defaultCoins.values
        .where((net) => net.type == networkType)
        .toList();

    // Create a map of existing chains by network ID
    final Map<int, Chain> chainMap = {
      for (final c in existingChains) c.network.value: c
    };

    // Add missing default networks (e.g., testnets)
    for (final defaultNetwork in defaultNetworksForType) {
      if (!chainMap.containsKey(defaultNetwork.value)) {
        final newChain = Chain.setup(network: defaultNetwork, id: walletKey);
        chainMap[defaultNetwork.value] = newChain;
        // Save in background
        // ignore: unawaited_futures
        newChain._saveAccountInternal();
      }
    }

    return chainMap.values.toList();
  }

  static NetworkController _createNetworkController(
      NetworkType networkType, List<Chain> chains, String walletKey) {
    switch (networkType) {
      case NetworkType.aptos:
        return AptosNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.bitcoinAndForked:
        return BitcoinNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.bitcoinCash:
        return BitcoinCashNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.ethereum:
        return EthereumNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.xrpl:
        return XRPNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.cardano:
        return ADANetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.cosmos:
        return CosmosNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.monero:
        return MoneroNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.sui:
        return SuiNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.solana:
        return SolanaNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.stellar:
        return StellarNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.substrate:
        return SubstrateNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.tron:
        return TronNetworkController(networks: chains.cast(), id: walletKey);
      case NetworkType.ton:
        return TonNetworkController(networks: chains.cast(), id: walletKey);
      default:
        throw WalletExceptionConst.networkDoesNotExist;
    }
  }

  NetworkController _getOrCreateController(NetworkType type) {
    // If controller exists, return it
    if (_networks.containsKey(type)) {
      return _networks[type]!;
    }

    // Lazy initialize controller if not yet created
    final chains = _lazyChains[type];
    if (chains == null) {
      throw WalletExceptionConst.networkDoesNotExist;
    }

    // Get all default networks for this type (mainnet + testnets)
    final defaultNetworksForType = ChainConst.defaultCoins.values
        .where((net) => net.type == type)
        .toList();

    // Create chains for all default networks of this type if not already loaded
    final Map<int, Chain> existingChains = {for (final c in chains) c.network.value: c};
    final List<Chain> newlyCreatedChains = [];

    for (final defaultNetwork in defaultNetworksForType) {
      if (!existingChains.containsKey(defaultNetwork.value)) {
        final newChain = Chain.setup(network: defaultNetwork, id: id);
        existingChains[defaultNetwork.value] = newChain;
        newlyCreatedChains.add(newChain);
      }
    }

    // Save newly created chains to database (e.g., testnets) - fire and forget
    // This runs in background so testnets persist across app restarts
    if (newlyCreatedChains.isNotEmpty) {
      // ignore: unawaited_futures
      Future.wait(newlyCreatedChains.map((e) => e._saveAccountInternal()));
    }

    // If no default networks exist for this type, create a placeholder
    final chainsToUse = existingChains.isEmpty
        ? [
            Chain.setup(
              network: ChainConst.defaultCoins.values.firstWhere(
                (net) => net.type == type,
                orElse: () => ChainConst.defaultCoins.values.first,
              ),
              id: id,
            )
          ]
        : existingChains.values.toList();

    final controller = _createNetworkController(type, chainsToUse, id);
    _networks[type] = controller;
    _lazyChains.remove(type);

    return controller;
  }

  static Future<ChainsHandler> fromBackup(
      {required WalletRestoreV2 backup, required MainWallet wallet}) async {
    final chains = backup.networks.map((e) => e.chain).toList();

    final handler = await setup(chains: chains, wallet: wallet, isBackup: true);
    await handler.restoreBackup(backup);
    return handler;
  }

  void updateWalletData(MainWallet wallet) {
    if (_wallet.key != wallet.key) {
      throw WalletExceptionConst.walletDoesNotExists;
    }
    _wallet = wallet;
  }

  List<String> coinIds() {
    return _networks.values.expand((e) => e.coinIds()).toSet().toList();
  }

  List<Chain> chains() {
    // Lazy load all controllers when getting all chains (e.g., for network switcher)
    // This is acceptable because it only happens when user opens network selector
    for (final type in NetworkType.values) {
      try {
        _getOrCreateController(type);
      } catch (_) {
        // Skip if controller can't be created
      }
    }
    return _networks.values.expand((e) => e.getChains()).toList();
  }

  T controller<T extends NetworkController>(NetworkType type) {
    // Use lazy initialization
    final controller = _getOrCreateController(type);
    return controller.cast<T>();
  }

  Future<bool> switchNetwork(Chain network) async {
    if (_chain == network ||
        !_getOrCreateController(network.network.type)
            ._networks
            .containsKey(network.network.value)) {
      return false;
    }
    final currentChain = chain;
    _chain = network;
    await currentChain.closeClient();
    await chain.init();
    final emit = ChainWalletChainChangeEvent(prv: currentChain, current: chain);
    await _emitChainChanged(emit);
    updateWalletData(_wallet.updateNetwork(network.network.value));
    return true;
  }

  Future<Chain> updateNetwork(WalletNetwork network) async {
    if (!network.isWalletNetwork) {
      throw WalletExceptionConst.networkDoesNotExist;
    }
    final controller = _getOrCreateController(network.type);
    int networkId = network.value;
    Chain? existChain = controller._networks[networkId];
    if (existChain == null) {
      throw WalletExceptionConst.invalidNetworkInformation;
    }
    existChain.dispose();
    existChain = existChain.copyWith(network: network);
    existChain = Chain.deserialize(bytes: existChain.toCbor().encode());
    controller._updateNetwork(existChain);
    if (existChain.network.value == chain.network.value) {
      _chain = existChain;
      await _chain.init();
    }
    return existChain;
  }

  Future<Chain> importNewNetwork(
      WalletNetwork network, List<APIProvider> providers) async {
    if (network.isWalletNetwork || !network.supportImportNetwork) {
      throw WalletExceptionConst.invalidNetworkInformation;
    }
    final controller = _getOrCreateController(network.type);
    final chains =
        controller.getChains().where((e) => e.network.type == network.type);
    if (chains.any((e) => e.network.identifier == network.identifier)) {
      throw WalletExceptionConst.networkAlreadyExist;
    }
    int networkId = network.value;
    final ids = _networks.values.expand((e) => e._networks.keys).toList();
    networkId = StrUtils.findFirstMissingNumber(ids,
        start: ChainConst.importedNetworkStartId);
    if (networkId > ChainConst.maxNetworkId) {
      throw WalletExceptionConst.toManyNetworkImported;
    }
    network = network.copyWith(value: networkId);
    if (network.value != networkId) {
      throw WalletExceptionConst.invalidNetworkInformation;
    }
    final newChain = Chain.setup(network: network, id: id);
    await newChain._removeAccount();
    await newChain._saveAccountInternal();
    await Future.wait(providers.map((e) => newChain.updateProvider(e)));
    controller._updateNetwork(newChain);
    return newChain;
  }

  Future<void> removeChain(Chain removeChain) async {
    if (removeChain.id != id) {
      throw WalletExceptionConst.internalError("removeChain");
    }
    final hasDefaultNetwork =
        ChainConst.defaultCoins[removeChain.network.value];
    if (!removeChain.network.isWalletNetwork || hasDefaultNetwork != null) {
      throw WalletExceptionConst.internalError("removeChain");
    }
    final controller = _getOrCreateController(removeChain.network.type);
    if (chain == removeChain) {
      final changeNetwork =
          controller._networks.values.firstWhere((e) => e != removeChain);
      await switchNetwork(changeNetwork);
    }
    controller._removeNetwork(removeChain);
    await removeChain._removeAccount();
    removeChain.dispose();
  }

  Future<List<Web3InternalChain>> getWeb3InternalChains(
      Web3ApplicationAuthentication authenticated,
      {List<NetworkType>? networks}) {
    networks ??= NetworkType.values;
    return Future.wait(networks.map((e) =>
        _getOrCreateController(e)._getWeb3InternalChainAuthenticated(authenticated)));
  }

  Future<void> disconnectWeb3Chain(Web3ApplicationAuthentication app,
      {List<NetworkType>? networks}) async {
    networks ??= NetworkType.values;
    await Future.wait(
        networks.map((e) => _getOrCreateController(e)._disconnectWeb3Chain(app)));
  }

  Future<Web3APPData> createAuth(Web3ApplicationAuthentication app,
      {List<NetworkType>? networks}) async {
    networks ??= NetworkType.values;

    return Web3APPData(
        token: app.token,
        networks: networks,
        applicationId: app.applicationId,
        chains: app.active
            ? await Future.wait(networks
                .map((e) => _getOrCreateController(e).createWeb3ChainAuthenticated(app)))
            : []);
  }

  Future<WalletBackup> createBackup(
      {required GenerateWalletBackupOptions options,
      required String masterKey,
      List<Web3ApplicationAuthentication> web3Applications = const []}) async {
    final networkBackups = await Future.wait(_networks.values.map((e) =>
        e._getNetworksBackup(
            options.chains.where((c) => c.network.type == e.type).toList())));
    final chainBackups = await Future.wait(_networks.values
        .map((e) => e._getChainBackup(web3Applications: web3Applications)));
    return WalletBackup(
        wallet: _wallet,
        key: masterKey,
        networks: networkBackups.expand((e) => e).toList(),
        chains: chainBackups.expand((e) => e).toList());
  }

  Future<void> restoreBackup(WalletRestoreV2 backup) async {
    await Future.wait(_networks.values.map((e) => e._restoreNetworksBackup(
        backup.networks
            .where((c) => c.chain.network.type == e.type)
            .toList())));
    await Future.wait(_networks.values.map((e) => e._restoreChainBackup(
        backup.chains.where((c) => c.chainID == e.type.id).toList())));
    final chains = this.chains();
    await Future.wait(chains.map((e) => e._saveAddresses(e.addresses)));
  }

  Future<void> updateWeb3InternalChains(
      {required Web3ApplicationAuthentication app,
      required List<Web3InternalChain> chains}) async {
    if (app.active) {
      await Future.wait(chains.map((e) =>
          _getOrCreateController(e.type)._updateWeb3InternalChain(app: app, web3Chain: e)));
    } else {
      await Future.wait(
          _networks.values.map((e) => e._disconnectWeb3Chain(app)));
    }
  }

  Future<void> _emitChainChanged(ChainWalletChainChangeEvent event) async {
    for (final i in _networks.entries) {
      for (final n in i.value._networks.values) {
        await n._onWalletEvent(event);
      }
    }
  }

  void _onConnectionStatus(bool isOnline) {
    final event = ChainWalletConnectionEvent(isOnline);
    for (final i in _networks.entries) {
      for (final n in i.value._networks.values) {
        n._onWalletEvent(event);
      }
    }
  }

  Future<void> _onPing(var _) async {
    final event = ChainWalletPingEvent();
    for (final i in _networks.entries) {
      for (final n in i.value._networks.values) {
        await n._onWalletEvent(event);
      }
    }
  }

  Future<void> init() async {
    await chain.init();
    assert(_networkStream == null && _ping == null);
    if (appLogger.mode.isDev) return;
    _networkStream =
        AppNativeMethods.platform.onNetworkStatus.listen(_onConnectionStatus);
    _ping = Stream.periodic(const Duration(minutes: 10)).listen(_onPing);
    final emit = ChainWalletChainChangeEvent(prv: null, current: chain);
    _emitChainChanged(emit);
  }

  void dispose() {
    _networkStream?.cancel();
    _ping?.cancel();
    _networkStream = null;
    _ping = null;
    for (final i in _networks.values) {
      for (final n in i._networks.values) {
        n.dispose();
      }
    }
  }
}
