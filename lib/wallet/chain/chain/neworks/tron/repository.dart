part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

base mixin TronChainRepository on Chain<
    TronAPIProvider,
    TronNetworkParams,
    TronAddress,
    TronToken,
    NFTCore,
    ITronAddress,
    WalletTronNetwork,
    TronClient,
    TronChainConfig,
    TronWalletTransaction,
    TronContact,
    TronNewAddressParams> {
  // Future<TronAccountInfo?> _getTronAccountInfo(ITronAddress address) async {
  //   assert(address.network == network.value, "address does not exists");
  //   if (address.network != network.value) {
  //     return null;
  //   }
  //   final storagekey = TronNetworkStorageId.accountInfo;
  //   final data = await _storage.queryNetworkStorage(
  //       address: address, storage: storagekey);
  //   if (data == null) return null;
  //   final accountInfo = MethodUtils.nullOnException(
  //       () => TronAccountInfo.deserialize(bytes: data));
  //   assert(accountInfo != null, 'tron account info deserialization failed.');
  //   return accountInfo;
  // }

  // Future<void> _saveTronAccountInfo(
  //     {required ITronAddress address,
  //     required TronAccountInfo? accountInfo}) async {
  //   assert(address.network == network.value, "address does not exists");
  //   if (address.network != network.value) {
  //     return;
  //   }
  //   final storageKey = TronNetworkStorageId.accountInfo;
  //   if (accountInfo == null) {
  //     await _storage.removeNetworkStorage(
  //         address: address, storage: storageKey);
  //     return;
  //   }
  //   await _storage.insertNetworkStorage(
  //       address: address, storage: storageKey, value: accountInfo);
  // }

  // Future<TronAccountResourceInfo?> _getTronAccountResource(
  //     ITronAddress address) async {
  //   assert(address.network == network.value, "address does not exists");
  //   if (address.network != network.value) {
  //     return null;
  //   }
  //   final storagekey = TronNetworkStorageId.accountResource;
  //   final data = await _storage.queryNetworkStorage(
  //       address: address, storage: storagekey);
  //   if (data == null) return null;
  //   final accountInfo = MethodUtils.nullOnException(
  //       () => TronAccountResourceInfo.deserialize(bytes: data));
  //   assert(
  //       accountInfo != null, 'tron account resource deserialization failed.');
  //   return accountInfo;
  // }

  // Future<void> _saveTronAccountResource(
  //     {required ITronAddress address,
  //     required TronAccountResourceInfo? accountResource}) async {
  //   assert(address.network == network.value, "address does not exists");
  //   if (address.network != network.value) {
  //     return;
  //   }
  //   final storagekey = TronNetworkStorageId.accountResource;
  //   if (accountResource == null) {
  //     await _storage.removeNetworkStorage(
  //         address: address, storage: storagekey);
  //     return;
  //   }
  //   await _storage.insertNetworkStorage(
  //       address: address, storage: storagekey, value: accountResource);
  // }
}
