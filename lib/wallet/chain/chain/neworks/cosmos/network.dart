part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class CosmosNetworkController extends NetworkController<ICosmosAddress,
    CosmosChain, Web3CosmosChainAccount, Web3InternalDefaultChain> {
  CosmosNetworkController({
    super.networks,
    required super.id,
  }) : super(type: NetworkType.cosmos);

  @override
  Future<Web3CosmosChainAuthenticated> createWeb3ChainAuthenticated(
    Web3ApplicationAuthentication app,
  ) async {
    final internalNetwork = await getWeb3InternalChainAuthenticated(app);
    final web3Networks = _networks.values
        .map((e) => Web3CosmoshainIdnetifier(
            id: e.network.value,
            chainId: e.network.coinParam.chainId,
            wsIdentifier: e.network.wsIdentifier,
            caip2: e.network.caip,
            hrp: e.network.coinParam.hrp))
        .toList();
    List<Web3CosmosChainAccount> web3Accounts = [];
    for (final i in internalNetwork.networks) {
      final network = _networks[i.networkId];
      if (network == null) continue;
      final networkAddresses = await network.getAccountAddresses();
      final List<ICosmosAddress> addresses = [];
      for (final a in i.accounts) {
        final address = networkAddresses.firstWhereOrNull(
            (e) => e.identifier == a.identifier && e.keyIndex == a.keyIndex);
        if (address == null) continue;
        addresses.add(address);
      }
      final defaultAddress = addresses.firstWhereOrNull((e) =>
              e.identifier == i.defaultAccount?.identifier &&
              e.keyIndex == i.defaultAccount?.keyIndex) ??
          addresses.firstOrNull;
      web3Accounts.addAll(addresses.map((e) =>
          Web3CosmosChainAccount.fromChainAccount(
              address: e, isDefault: e == defaultAddress, id: e.network)));
    }
    return Web3CosmosChainAuthenticated(
        accounts: web3Accounts,
        currentNetwork: web3Networks
            .firstWhere((e) => e.id == internalNetwork.defaultChain),
        networks: web3Networks);
  }
}
