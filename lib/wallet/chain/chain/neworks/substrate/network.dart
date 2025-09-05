part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class SubstrateNetworkController extends NetworkController<ISubstrateAddress,
    SubstrateChain, Web3SubstrateChainAccount, Web3InternalDefaultChain> {
  SubstrateNetworkController({
    super.networks,
    required super.id,
  }) : super(type: NetworkType.substrate);

  @override
  Future<Web3SubstrateChainAuthenticated> createWeb3ChainAuthenticated(
    Web3ApplicationAuthentication app,
  ) async {
    final internalNetwork = await getWeb3InternalChainAuthenticated(app);
    final web3Networks = _networks.values
        .map((e) => Web3SubstrateChainIdnetifier(
            genesisHash: e.network.genesisBlock,
            specVersion: e.network.coinParam.specVersion,
            id: e.network.value,
            wsIdentifier: e.network.wsIdentifier,
            caip2: e.network.caip,
            type: e.network.coinParam.substrateChainType,
            ss58Fromat: e.network.coinParam.ss58Format))
        .toList();
    List<Web3SubstrateChainAccount> web3Accounts = [];
    for (final i in internalNetwork.networks) {
      final network = _networks[i.networkId];
      if (network == null) continue;
      final networkAddresses = await network.getAccountAddresses();
      final List<ISubstrateAddress> addresses = [];
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
          Web3SubstrateChainAccount.fromChainAccount(
              address: e, isDefault: e == defaultAddress, id: e.network)));
    }
    return Web3SubstrateChainAuthenticated(
        accounts: web3Accounts,
        currentNetwork: web3Networks
            .firstWhere((e) => e.id == internalNetwork.defaultChain),
        networks: web3Networks);
  }
}
