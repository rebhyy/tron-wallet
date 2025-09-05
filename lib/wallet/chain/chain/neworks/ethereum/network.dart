part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class EthereumNetworkController extends NetworkController<IEthAddress,
    EthereumChain, Web3EthereumChainAccount, Web3InternalDefaultChain> {
  EthereumNetworkController({
    super.networks,
    required super.id,
  }) : super(type: NetworkType.ethereum);

  @override
  Future<Web3EthereumChainAuthenticated> createWeb3ChainAuthenticated(
    Web3ApplicationAuthentication app,
  ) async {
    final internalNetwork = await getWeb3InternalChainAuthenticated(app);
    final web3Networks = _networks.values
        .map((e) => Web3EthereumChainIdnetifier(
              id: e.network.value,
              chainId: e.network.coinParam.chainId,
              supportEIP1559: e.network.coinParam.supportEIP1559,
              wsIdentifier: e.network.wsIdentifier,
              caip2: e.network.caip,
            ))
        .toList();
    List<Web3EthereumChainAccount> web3Accounts = [];
    for (final i in internalNetwork.networks) {
      final network = _networks[i.networkId];
      if (network == null) continue;
      final networkAddresses = await network.getAccountAddresses();
      final List<IEthAddress> addresses = [];
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
      web3Accounts.addAll(
          addresses.map((e) => Web3EthereumChainAccount.fromChainAccount(
                address: e,
                isDefault: e == defaultAddress,
                id: e.network,
              )));
    }
    final currentNetwork = _networks[internalNetwork.defaultChain]!;
    final provider = APIUtils.findNetworkProvider<EthereumAPIProvider>(
        currentNetwork.network,
        identifier: currentNetwork.serviceIdentifier,
        allowInWeb3: true);
    return Web3EthereumChainAuthenticated(
        accounts: web3Accounts,
        networks: web3Networks,
        currentNetwork: web3Networks
            .firstWhere((e) => e.id == internalNetwork.defaultChain),
        serviceIdentifier: provider);
  }
}
