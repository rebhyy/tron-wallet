part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class ADANetworkController extends NetworkController<ICardanoAddress, ADAChain,
    Web3ADAChainAccount, Web3InternalADAChain> {
  ADANetworkController({
    super.networks,
    required super.id,
  }) : super(type: NetworkType.cardano);

  @override
  Future<(ADAChain, List<ICardanoAddress>)?> getWeb3AuthenticatedAccounts(
      Web3ApplicationAuthentication app,
      List<Web3ADAChainAccount> web3Accounts) async {
    final internalChain = await getWeb3InternalChainAuthenticated(app);
    if (web3Accounts.isEmpty) {
      return (
        _networks[internalChain.defaultChain] ?? _networks.values.first,
        <ICardanoAddress>[]
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
    List<ICardanoAddress> addresses = [];
    for (final i in web3Accounts) {
      final authAddress = internalNetwork.accounts.firstWhereOrNull((e) =>
          e.identifier == i.identifier &&
          e.keyIndex == i.keyIndex &&
          e.type.isReward == i.isRewardAddress);
      ICardanoAddress? address = switch (i.isRewardAddress) {
        false => networkAddresses.firstWhereOrNull((e) =>
            e.identifier == i.identifier &&
            e.keyIndex == i.keyIndex &&
            !e.isRewardAddress),
        true => networkAddresses.firstWhereOrNull((e) =>
            e.identifier == i.identifier &&
            (e.rewardKeyIndex ?? e.keyIndex) == i.keyIndex &&
            (e.isRewardAddress || e.isBaseAddress))
      };
      if (address == null || authAddress == null) return null;
      addresses.add(address.cast<ICardanoAddress>());
    }
    return (network, addresses);
  }

  @override
  Future<Web3InternalADAChain> getWeb3InternalChainAuthenticated(
      Web3ApplicationAuthentication app) async {
    final data = await _storage.queryChainStorage(
        storage: DefaultChainStorageId.web3, key: app.applicationId);
    if (data == null) {
      return Web3InternalADAChain(
        networks: _networks.values
            .map((e) => Web3InternalADANetwork(
                accounts: [], networkId: e.network.value))
            .toList(),
        defaultChain: _networks.keys.first,
      );
    }
    Web3InternalADAChain web3Chain =
        Web3InternalADAChain.deserialize(bytes: data);
    web3Chain = Web3InternalADAChain(
        networks: _networks.values.map((e) {
          final network = web3Chain.networks
              .firstWhereNullable((i) => i.networkId == e.network.value);
          return Web3InternalADANetwork(
              accounts: network?.accounts ?? [],
              networkId: e.network.value,
              defaultAccount: network?.defaultAccount);
        }).toList(),
        defaultChain: _networks[web3Chain.defaultChain]?.network.value ??
            _networks.keys.first);
    return web3Chain;
  }

  @override
  Future<Web3ADAChainAuthenticated> createWeb3ChainAuthenticated(
    Web3ApplicationAuthentication app,
  ) async {
    final internalNetwork = await getWeb3InternalChainAuthenticated(app);
    final web3Networks = _networks.values
        .map((e) => Web3ADAChainIdnetifier(
            id: e.network.value,
            wsIdentifier: e.network.wsIdentifier,
            caip2: e.network.caip,
            network: e.network.coinParam.networkType))
        .toList();
    List<Web3ADAChainAccount> web3Accounts = [];
    for (final i in internalNetwork.networks) {
      final network = _networks[i.networkId];
      if (network == null) continue;
      final networkAddresses = await network.getAccountAddresses();
      final List<ICardanoAddress> addresses = [];
      final List<ICardanoAddress> rewardAddress = [];
      for (final a in i.accounts) {
        ICardanoAddress? address;
        if (a.type.isPayment) {
          address = networkAddresses.firstWhereOrNull((e) =>
              e.identifier == a.identifier &&
              !e.isRewardAddress &&
              e.keyIndex == a.keyIndex);
          if (address == null) continue;
          addresses.add(address);
        } else {
          address = networkAddresses.firstWhereOrNull((e) =>
              e.identifier == a.identifier &&
              (e.rewardKeyIndex ?? e.keyIndex) == a.keyIndex &&
              (e.isRewardAddress || e.isBaseAddress));
          if (address == null) continue;
          rewardAddress.add(address);
        }
      }
      final defaultAddress = addresses.firstWhereOrNull((e) =>
              e.identifier == i.defaultAccount?.identifier &&
              e.keyIndex == i.defaultAccount?.keyIndex &&
              !e.isRewardAddress) ??
          addresses.firstOrNull;
      web3Accounts.addAll(await Future.wait(
          addresses.map((e) async => Web3ADAChainAccount.fromChainAccount(
              address: e,
              id: network.network.value,
              isDefault: e == defaultAddress,
              isRewardAddress: false,
              utxos: switch (instance) {
                ChainsHandlerInstance.main =>
                  await network._getLatestTransactionUnspentOutputs(e),
                ChainsHandlerInstance.background =>
                  await network._getTransactionUnspentOutputs(e)
              }))));
      web3Accounts.addAll(rewardAddress.map((e) =>
          Web3ADAChainAccount.fromChainAccount(
              address: e,
              id: network.network.value,
              isDefault: false,
              isRewardAddress: true,
              utxos: [])));
    }

    return Web3ADAChainAuthenticated(
        accounts: web3Accounts,
        currentNetwork: web3Networks
            .firstWhere((e) => e.id == internalNetwork.defaultChain),
        networks: web3Networks);
  }
}
