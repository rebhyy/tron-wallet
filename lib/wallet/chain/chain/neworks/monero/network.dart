part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class MoneroNetworkController extends NetworkController<IMoneroAddress,
    MoneroChain, Web3MoneroChainAccount, Web3InternalDefaultChain> {
  MoneroNetworkController({
    super.networks,
    required super.id,
  }) : super(type: NetworkType.monero);

  @override
  Future<Web3MoneroChainAuthenticated> createWeb3ChainAuthenticated(
    Web3ApplicationAuthentication app,
  ) async {
    final internalNetwork = await getWeb3InternalChainAuthenticated(app);
    final web3Networks = _networks.values
        .map((e) => Web3MoneroChainIdnetifier(
            id: e.network.value,
            wsIdentifier: e.network.wsIdentifier,
            caip2: e.network.caip,
            network: e.network.coinParam.network))
        .toList();
    List<Web3MoneroChainAccount> web3Accounts = [];
    for (final i in internalNetwork.networks) {
      final network = _networks[i.networkId];
      if (network == null) continue;
      final networkAddresses = await network.getAccountAddresses();
      final List<IMoneroAddress> addresses = [];
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
          Web3MoneroChainAccount.fromChainAccount(
              address: e, isDefault: e == defaultAddress, id: e.network)));
    }
    return Web3MoneroChainAuthenticated(
        accounts: web3Accounts,
        currentNetwork: web3Networks
            .firstWhere((e) => e.id == internalNetwork.defaultChain),
        networks: web3Networks);
  }
}
