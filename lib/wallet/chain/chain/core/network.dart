part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

abstract class NetworkController<ACCOUNT extends ChainAccount, T extends Chain,
    WEB3 extends Web3ChainAccount, WEB3CHAIN extends Web3InternalChain> {
  final NetworkType type;
  final ChainStorageManager _storage;
  Map<int, T> _networks = {};

  List<T> get networks => _networks.values.toList();
  NetworkController(
      {List<T> networks = const [], required this.type, required String id})
      : _networks = {for (final i in networks) i.network.value: i},
        _storage = ChainStorageManager(id: id, networkType: type);
  List<T> getChains() {
    return _networks.values.toList();
  }

  void _removeNetwork(T network) {
    final networks = _networks.clone();
    final remove = networks.remove(network.network.value);
    assert(remove != null, "network does not exists");
    _networks = networks.immutable;
  }

  void _updateNetwork(T chain) {
    final networks = _networks.clone();
    networks[chain.network.value] = chain;
    _networks = networks.immutable;
  }

  List<String> coinIds() {
    final ids = _networks.values
        .map((e) => e.tokens().map((e) => e.token.market?.apiId))
        .expand((e) => e)
        .where((element) => element != null);
    final networkIds = _networks.values
        .map((e) => e.network.token.market?.apiId)
        .where((element) => element != null);
    return List<String>.from([...ids, ...networkIds]);
  }

  Future<void> updateWeb3InternalChain(
      {required Web3ApplicationAuthentication app,
      required WEB3CHAIN web3Chain}) async {
    await _storage.insertChainStorage(
        value: web3Chain,
        storage: DefaultChainStorageId.web3,
        key: app.applicationId);
  }

  Future<void> disconnectWeb3Chain(Web3ApplicationAuthentication app) async {
    await _storage.removeChainStorage(
        storage: DefaultChainStorageId.web3, key: app.applicationId);
  }

  Future<WEB3CHAIN> getWeb3InternalChainAuthenticated(
      Web3ApplicationAuthentication app) async {
    final data = await _storage.queryChainStorage(
        storage: DefaultChainStorageId.web3, key: app.applicationId);
    if (data == null) {
      return Web3InternalDefaultChain(
              networks: _networks.values
                  .map((e) => Web3InternalDefaultNetwork(
                      accounts: [], networkId: e.network.value))
                  .toList(),
              defaultChain: _networks.keys.first,
              type: type)
          .cast<WEB3CHAIN>();
    }
    Web3InternalDefaultChain web3Chain =
        Web3InternalDefaultChain.deserialize(bytes: data);
    web3Chain = Web3InternalDefaultChain(
        networks: _networks.values.map((e) {
          final network = web3Chain.networks
              .firstWhereNullable((i) => i.networkId == e.network.value);
          return Web3InternalDefaultNetwork(
              accounts: network?.accounts ?? [],
              networkId: e.network.value,
              defaultAccount: network?.defaultAccount);
        }).toList(),
        defaultChain: _networks[web3Chain.defaultChain]?.network.value ??
            _networks.keys.first,
        type: type);
    return web3Chain.cast<WEB3CHAIN>();
  }

  Future<(T, List<ACCOUNT>)?> getWeb3AuthenticatedAccounts(
      Web3ApplicationAuthentication app, List<WEB3> web3Accounts) async {
    final internalChain = await getWeb3InternalChainAuthenticated(app);
    if (web3Accounts.isEmpty) {
      return (
        _networks[internalChain.defaultChain] ?? _networks.values.first,
        <ACCOUNT>[]
      );
    }
    final isValidAccounts = web3Accounts.map((e) => e.id).toSet().length == 1;
    if (!isValidAccounts) return null;
    final int networkId = web3Accounts.first.id;
    final network = _networks[networkId];
    final internalNetwork = internalChain.networks
        .firstWhereOrNull((e) => e.networkId == networkId);
    if (network == null || internalNetwork == null) return null;
    final networkAddresses = await network.getAccountAddresses();
    List<ACCOUNT> addresses = [];
    for (final i in web3Accounts) {
      final authAddress = internalNetwork.accounts.firstWhereOrNull(
          (e) => e.identifier == i.identifier && e.keyIndex == i.keyIndex);
      final address = networkAddresses.firstWhereOrNull(
          (e) => e.identifier == i.identifier && e.keyIndex == i.keyIndex);
      if (address == null || authAddress == null) return null;
      addresses.add(address.cast<ACCOUNT>());
    }
    return (network, addresses);
  }

  Future<Web3ChainAuthenticated<WEB3>> createWeb3ChainAuthenticated(
      Web3ApplicationAuthentication app);

  Future<List<WalletNetworkBackup>> getNetworksBackup(
      List<Chain> chains) async {
    if (chains.isEmpty) return [];
    final correctChains =
        chains.where((e) => _networks.containsKey(e.network.value)).toList();
    assert(correctChains.length == chains.length, "invalid backup chains");
    return (await Future.wait(correctChains.map((e) async =>
        WalletNetworkBackup(
            chain: e, repositories: await e._storage.readAllRepositories()))));
  }

  Future<List<WalletBackupChainRepository>> getChainBackup(
      {List<Web3ApplicationAuthentication> web3Applications = const []}) async {
    return await _storage.readAllChainRepositories(
        web3Identifier: web3Applications.map((e) => e.applicationId).toList());
  }

  Future<void> restoreNetworksBackup(
      List<WalletNetworkBackup> chainsBackup) async {
    for (final i in chainsBackup) {
      final network = _networks[i.chain.network.value];
      assert(network != null, "network does not exists");
      if (network == null) continue;
      await network._storage.restoreNetworkRepositories(i.repositories);
    }
  }

  Future<void> restoreChainBackup(
      List<WalletBackupChainRepository> chainsBackup) async {
    final backups = chainsBackup.where((e) => e.chainID == type.id).toList();
    assert(backups.length == chainsBackup.length, "invalid chain backups");
    await _storage.restoreChainRepositories(backups);
  }
}
