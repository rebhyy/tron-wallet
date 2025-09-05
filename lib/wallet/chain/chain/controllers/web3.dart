part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

base mixin BaseChainWeb3Controller<
        PROVIDER extends APIProvider,
        NETWORKPARAMS extends NetworkCoinParams,
        NETWORKADDRESS,
        TOKEN extends TokenCore,
        NFT extends NFTCore,
        ADDRESS extends ChainAccount,
        NETWORK extends WalletNetwork,
        CLIENT extends NetworkClient,
        CONFIG extends DefaultNetworkConfig,
        TRANSACTION extends ChainTransaction,
        CONTACT extends ContactCore,
        ADDRESSPARAM extends NewAccountParams>
    on
        BaseChain<PROVIDER, NETWORKPARAMS, NETWORKADDRESS, TOKEN, NFT, ADDRESS,
            NETWORK, CLIENT, CONFIG, TRANSACTION, CONTACT, ADDRESSPARAM>,
        ChainRepository<ADDRESS, NETWORK, CLIENT, CONFIG, TOKEN, NFT,
            TRANSACTION, CONTACT, ADDRESSPARAM> {
  Web3InternalDefaultNetwork buildWeb3InternalNetwork(
      Web3InternalDefaultNetwork web3Chain) {
    final accounts = web3Chain.accounts;
    List<Web3InternalDefaultNetworkAccount> updateAccounts = [];
    for (final i in accounts) {
      if (_addresses.any(
          (e) => e.keyIndex == i.keyIndex && i.identifier == e.identifier)) {
        updateAccounts.add(i);
      }
    }
    Web3InternalDefaultNetworkAccount? defaultAddress =
        web3Chain.defaultAccount;
    if (defaultAddress != null) {
      defaultAddress = updateAccounts.firstWhereOrNull((e) =>
          e.keyIndex == defaultAddress!.keyIndex &&
          e.identifier == defaultAddress.identifier);
    }
    return Web3InternalDefaultNetwork(
        accounts: updateAccounts,
        defaultAccount: defaultAddress ?? updateAccounts.firstOrNull,
        networkId: network.value);
  }

  // Future<Web3InternalDefaultNetwork> getWeb3ApllicationAuthenticated(
  //     Web3ApplicationAuthentication authenticated) async {
  //   final storageId = DefaultNetworkStorageId.web3;
  // final data = await _storage.queryNetworkStorage(
  //     storage: storageId, keyA: authenticated.applicationId);
  //   if (data == null) return Web3InternalDefaultNetwork(accounts: []);
  //   final web3Chain = Web3InternalDefaultNetwork.deserialize(bytes: data);
  //   final accounts = web3Chain.accounts;
  //   List<Web3InternalDefaultNetworkAccount> updateAccounts = [];
  //   for (final i in accounts) {
  //     if (addresses.any(
  //         (e) => e.keyIndex == i.keyIndex && i.identifier == e.identifier)) {
  //       updateAccounts.add(i);
  //     }
  //   }
  //   Web3InternalDefaultNetworkAccount? defaultAddress = web3Chain.defaultAccount;
  //   if (defaultAddress != null) {
  //     defaultAddress = updateAccounts.firstWhereOrNull((e) =>
  //         e.keyIndex == defaultAddress!.keyIndex &&
  //         e.identifier == defaultAddress.identifier);
  //   }
  //   return Web3InternalDefaultNetwork(
  //       accounts: updateAccounts,
  //       defaultAccount: defaultAddress ?? updateAccounts.firstOrNull);
  // }
}
