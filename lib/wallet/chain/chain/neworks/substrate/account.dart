part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class SubstrateChain extends Chain<
    SubstrateAPIProvider,
    SubstrateNetworkParams,
    BaseSubstrateAddress,
    TokenCore,
    NFTCore,
    ISubstrateAddress,
    WalletSubstrateNetwork,
    SubstrateClient,
    DefaultNetworkConfig,
    SubstrateWalletTransaction,
    SubstrateContact,
    SubstrateNewAddressParams> {
  SubstrateChain._(
      {required super.network,
      required super.addressIndex,
      required super.id,
      DefaultNetworkConfig? config,
      required super.client,
      required super.addresses,
      super.totalBalance})
      : super._(config: config ?? DefaultNetworkConfig.defaultConfig);
  @override
  SubstrateChain copyWith(
      {WalletSubstrateNetwork? network,
      List<ChainAccount>? addresses,
      int? addressIndex,
      SubstrateClient? client,
      String? id,
      DefaultNetworkConfig? config,
      BigInt? totalBalance}) {
    return SubstrateChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<ISubstrateAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config);
  }

  factory SubstrateChain.setup({
    required WalletSubstrateNetwork network,
    required String id,
    SubstrateClient? client,
  }) {
    return SubstrateChain._(
        network: network,
        id: id,
        addressIndex: 0,
        client: client,
        addresses: []);
  }

  factory SubstrateChain.deserialize(
      {required WalletSubstrateNetwork network,
      required CborListValue cbor,
      SubstrateClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<ISubstrateAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => ISubstrateAddress.deserialize(network, obj: e))
        .toList();
    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return SubstrateChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  @override
  Future<void> _updateAddressBalanceInternal(ISubstrateAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      final balance = await client.getAccountBalance(address.networkAddress);
      address._updateAddressBalance(balance);
    });
  }

  @override
  Future<void> updateTokenBalance(
      {required ISubstrateAddress address,
      required List<TokenCore<BalanceCore<dynamic, APPToken>, APPToken>>
          tokens}) async {}

  @override
  ISubstrateAddress _deserializeAddress(List<int> adressBytes) {
    return ISubstrateAddress.deserialize(network, bytes: adressBytes);
  }
}
