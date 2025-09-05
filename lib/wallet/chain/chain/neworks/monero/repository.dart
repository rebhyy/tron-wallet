part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

base mixin MoneroChainRepository on Chain<
    MoneroAPIProvider,
    MoneroNetworkParams,
    MoneroAddress,
    TokenCore,
    NFTCore,
    IMoneroAddress,
    WalletMoneroNetwork,
    MoneroClient,
    MoneroNetworkConfig,
    MoneroWalletTransaction,
    MoneroContact,
    MoneroNewAddressParams> {
  MoneroAccountBlocksTracker get defaultTracker;
  MoneroAddressUtxos get _accountUtxos;

  Future<void> _saveDefaultTracker() async {
    await _storage.insertNetworkStorage(
        storage: MoneroNetworkStorageId.defaultTracker, value: defaultTracker);
  }

  Future<MoneroAccountBlocksTracker> _getDefaultTracker() async {
    try {
      final data = await _storage.queryNetworkStorage(
          storage: MoneroNetworkStorageId.defaultTracker);
      if (data == null) {
        return MoneroAccountBlocksTracker.start();
      }
      return MoneroAccountBlocksTracker.deserialize(bytes: data);
    } catch (e) {
      assert(false, "tracker deserialization failed.");
      return MoneroAccountBlocksTracker.start();
    }
  }

  Future<MoneroSyncChain> _getSyncChain() async {
    final data = await _storage.queryChainStorage(
        storage: MoneroChainStorageId.syncChain);
    if (data == null) {
      return MoneroSyncChain.mainnet;
    }
    return MoneroSyncChain.deserialize(bytes: data);
  }

  Future<void> _saveSyncChain(MoneroSyncChain syncChain) async {
    await _storage.insertChainStorage(
        storage: MoneroChainStorageId.syncChain, value: syncChain);
  }

  Future<MoneroAPIProvider?> _getWalletRPC() async {
    final data = await _storage.queryNetworkStorage(
        storage: MoneroNetworkStorageId.walletRPC);
    if (data == null) return null;
    return MoneroAPIProvider.fromCborBytesOrObject(bytes: data);
  }

  Future<MoneroWalletClient?> _getWalletClient() async {
    final provider = await _getWalletRPC();
    if (provider == null) return null;
    return MoneroWalletClient(provider, network);
  }

  Future<void> _saveWalletRpc(MoneroAPIProvider? provider) async {
    if (provider == null) {
      await _storage.removeNetworkStorage(
          storage: MoneroNetworkStorageId.walletRPC);
      return;
    }

    await _storage.insertNetworkStorage(
        storage: MoneroNetworkStorageId.walletRPC, value: provider);
  }

  Future<void> _saveUtxos() async {
    final storageKey = MoneroNetworkStorageId.addressUtxos;
    await _storage.insertNetworkStorage(
        storage: storageKey, value: _accountUtxos);
  }

  Future<MoneroAddressUtxos> _getAccountUtxos() async {
    final storagekey = MoneroNetworkStorageId.addressUtxos;
    final data = await _storage.queryNetworkStorage(storage: storagekey);
    if (data == null) return MoneroAddressUtxos();
    try {
      return MoneroAddressUtxos.deserialize(bytes: data);
    } catch (e) {
      assert(false, 'monero address deserialization failed. $e');
      return MoneroAddressUtxos();
    }
  }
}
