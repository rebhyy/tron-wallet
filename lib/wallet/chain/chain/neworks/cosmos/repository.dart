part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

base mixin CosmosChainRepository on Chain<
    CosmosAPIProvider,
    CosmosNetworkParams,
    CosmosBaseAddress,
    CW20Token,
    NFTCore,
    ICosmosAddress,
    WalletCosmosNetwork,
    CosmosClient,
    CosmosNetworkConfig,
    CosmosWalletTransaction,
    CosmosContact,
    CosmosNewAddressParams> {
  CosmosAccountIBCChannelIds _channelId = CosmosAccountIBCChannelIds();
  CosmosAccountIBCChannelIds get channelId => _channelId;
  Future<void> _loadChannelIds() async {
    final data = await _storage.queryNetworkStorage(
        storage: CosmosNetowkStorageId.channelIds);
    if (data == null) return;
    _channelId = CosmosAccountIBCChannelIds.deserialize(bytes: data);
  }

  Future<void> _saveChannelId(CosmosIBCChannelId channel) async {
    _channelId.addChannel(channel);
    await _storage.insertNetworkStorage(
        storage: CosmosNetowkStorageId.channelIds, value: _channelId);
  }
}
