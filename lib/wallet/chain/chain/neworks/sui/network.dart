part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class SuiNetworkController extends NetworkController<ISuiAddress, SuiChain,
    Web3SuiChainAccount, Web3InternalDefaultChain> {
  SuiNetworkController({
    super.networks,
    required super.id,
  }) : super(type: NetworkType.sui);

  @override
  Future<Web3SuiChainAuthenticated> createWeb3ChainAuthenticated(
    Web3ApplicationAuthentication app,
  ) async {
    final internalNetwork = await getWeb3InternalChainAuthenticated(app);
    final web3Networks = _networks.values
        .map((e) => Web3ChainDefaultIdnetifier(
              id: e.network.value,
              wsIdentifier: e.network.wsIdentifier,
              caip2: e.network.caip,
            ))
        .toList();
    List<Web3SuiChainAccount> web3Accounts = [];
    for (final i in internalNetwork.networks) {
      final network = _networks[i.networkId];
      if (network == null) continue;
      final networkAddresses = await network.getAccountAddresses();
      final List<ISuiAddress> addresses = [];
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
          Web3SuiChainAccount.fromChainAccount(
              address: e,
              isDefault: e == defaultAddress,
              id: e.network,
              network: network.network.coinParam.suiChain)));
    }
    return Web3SuiChainAuthenticated(
        accounts: web3Accounts,
        currentNetwork: web3Networks
            .firstWhere((e) => e.id == internalNetwork.defaultChain),
        networks: web3Networks);
  }
}
