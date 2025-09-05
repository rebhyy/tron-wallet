part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class TronNetworkController extends NetworkController<ITronAddress, TronChain,
    Web3TronChainAccount, Web3InternalDefaultChain> {
  TronNetworkController({
    super.networks,
    required super.id,
  }) : super(type: NetworkType.tron);

  @override
  Future<Web3TronChainAuthenticated> createWeb3ChainAuthenticated(
    Web3ApplicationAuthentication app,
  ) async {
    final internalNetwork = await getWeb3InternalChainAuthenticated(app);

    final web3Networks = _networks.values.map((e) {
      final tron = APIUtils.findNetworkProvider<TronAPIProvider>(e.network,
          identifier: e.serviceIdentifier, allowInWeb3: true);
      return Web3TronChainIdnetifier(
        id: e.network.value,
        chainId: e.network.tronNetworkType.genesisBlockNumber,
        solidityNode: tron!.solidityProvider.callUrl,
        fullNode: tron.callUrl,
        wsIdentifier: e.network.wsIdentifier,
        caip2: e.network.caip,
      );
    }).toList();
    List<Web3TronChainAccount> web3Accounts = [];
    for (final i in internalNetwork.networks) {
      final network = _networks[i.networkId];
      if (network == null) continue;
      final networkAddresses = await network.getAccountAddresses();
      final List<ITronAddress> addresses = [];
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
          Web3TronChainAccount.fromChainAccount(
              address: e, isDefault: e == defaultAddress, id: e.network)));
    }
    return Web3TronChainAuthenticated(
        accounts: web3Accounts,
        currentNetwork: web3Networks
            .firstWhere((e) => e.id == internalNetwork.defaultChain),
        networks: web3Networks);
  }
}
