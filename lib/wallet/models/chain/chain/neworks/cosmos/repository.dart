part of 'package:on_chain_wallet/wallet/models/chain/chain/chain.dart';

base mixin CosmosChainRepository on Chain<
    CosmosAPIProvider,
    CosmosNetworkParams,
    CosmosBaseAddress,
    CW20Token,
    NFTCore,
    ICosmosAddress,
    WalletCosmosNetwork,
    CosmosClient,
    ChainStorageKey,
    CosmosChainConfig,
    CosmosWalletTransaction,
    CosmosContact,
    CosmosNewAddressParams> {
  CosmosAccountIBCChannelIds _channelId = CosmosAccountIBCChannelIds();
  CosmosAccountIBCChannelIds get channelId => _channelId;
  Future<void> _loadChannelIds() async {
    final data = await _storage.queryChainStorage(
        storage: CosmosChainStorage.channelIds);
    if (data == null) return;
    _channelId = CosmosAccountIBCChannelIds.deserialize(bytes: data);
  }

  Future<void> _saveChannelId(CosmosIBCChannelId channel) async {
    _channelId.addChannel(channel);
    await _storage.insertChainStorage(
        storage: CosmosChainStorage.channelIds, value: _channelId);
  }
}
