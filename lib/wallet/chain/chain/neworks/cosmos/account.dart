part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class CosmosNetowkStorageId extends DefaultNetworkStorageId {
  static const CosmosNetowkStorageId channelIds = CosmosNetowkStorageId(11);
  const CosmosNetowkStorageId(super.storageId);
  static const List<DefaultNetworkStorageId> values = [
    ...DefaultNetworkStorageId.values,
    channelIds
  ];
}

class CosmosNetworkConfig extends DefaultNetworkConfig<CosmosNetowkStorageId> {
  CosmosNetworkConfig()
      : super(supportToken: true, supportNft: false, supportWeb3: true);
  factory CosmosNetworkConfig.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    return CosmosNetworkConfig();
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([]), CborTagsConst.cosmosChainConfig);
  }

  @override
  List<DefaultNetworkStorageId> get storageKeys => CosmosNetowkStorageId.values;
}

final class CosmosChain extends Chain<
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
    CosmosNewAddressParams> with CosmosChainRepository {
  CosmosChain._(
      {required super.network,
      required super.addressIndex,
      required super.id,
      required super.config,
      required super.client,
      required super.addresses,
      super.totalBalance})
      : super._();
  @override
  CosmosChain copyWith(
      {WalletCosmosNetwork? network,
      List<ChainAccount>? addresses,
      int? addressIndex,
      CosmosClient? client,
      String? id,
      CosmosNetworkConfig? config,
      BigInt? totalBalance}) {
    return CosmosChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<ICosmosAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance._value.balance);
  }

  factory CosmosChain.setup(
      {required WalletCosmosNetwork network,
      required String id,
      CosmosClient? client}) {
    return CosmosChain._(
        network: network,
        id: id,
        addressIndex: 0,
        client: client,
        addresses: [],
        config: CosmosNetworkConfig());
  }
  factory CosmosChain.deserialize(
      {required WalletCosmosNetwork network,
      required CborListValue cbor,
      CosmosClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<ICosmosAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => ICosmosAddress.deserialize(network, obj: e))
        .toList();
    int addressIndex = cbor.elementAs(4);
    BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return CosmosChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        config: CosmosNetworkConfig(),
        totalBalance: totalBalance);
  }

  @override
  Future<void> _updateAddressBalanceInternal(ICosmosAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      final balances = await client.getAddressCoins(address.networkAddress);
      final nativeToken =
          balances.firstWhereOrNull((e) => e.denom == network.coinParam.denom);
      address._updateAddressBalance(nativeToken?.amount ?? BigInt.zero);
      for (final i in address.tokens) {
        final balance = balances.firstWhereOrNull((e) => e.denom == i.denom);
        await address._updateTokenBalance(
            i, () => i._updateBalance(balance?.amount ?? BigInt.zero));
      }
    });
  }

  Future<void> saveChannelId(CosmosIBCChannelId channel) async {
    await _callSynchronized(t: () async {
      await _saveChannelId(channel);
    });
  }

  @override
  Future<void> _initInternal({bool client = true}) async {
    await super._initInternal(client: client);
    _loadChannelIds();
  }

  @override
  Future<void> updateTokenBalance(
      {required ICosmosAddress address,
      required List<CW20Token> tokens}) async {
    await onClient(onConnect: (client) async {
      final balances = await client.getAddressCoins(address.networkAddress);
      final nativeToken =
          balances.firstWhereOrNull((e) => e.denom == network.coinParam.denom);
      address._updateAddressBalance(nativeToken?.amount ?? BigInt.zero);
      for (final i in tokens) {
        final balance = balances.firstWhereOrNull((e) => e.denom == i.denom);
        address._updateTokenBalance(
            i, () => i._updateBalance(balance?.amount ?? BigInt.zero));
      }
    });
  }

  @override
  ICosmosAddress _deserializeAddress(List<int> adressBytes) {
    return ICosmosAddress.deserialize(network, bytes: adressBytes);
  }
}
