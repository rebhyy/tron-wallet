part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class SuiChain extends Chain<
    SuiAPIProvider,
    SuiNetworkParams,
    SuiAddress,
    SuiToken,
    NFTCore,
    ISuiAddress,
    WalletSuiNetwork,
    SuiClient,
    DefaultNetworkConfig,
    SuiWalletTransaction,
    SuiContact,
    SuiNewAddressParams> {
  SuiChain._({
    required super.network,
    required super.addressIndex,
    required super.id,
    DefaultNetworkConfig? config,
    required super.client,
    required super.addresses,
    super.totalBalance,
  }) : super._(config: config ?? DefaultNetworkConfig.defaultConfig);
  @override
  SuiChain copyWith(
      {WalletSuiNetwork? network,
      List<ChainAccount>? addresses,
      int? addressIndex,
      SuiClient? client,
      String? id,
      DefaultNetworkConfig? config,
      BigInt? totalBalance}) {
    return SuiChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<ISuiAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? totalBalance);
  }

  factory SuiChain.setup(
      {required WalletSuiNetwork network,
      required String id,
      SuiClient? client}) {
    return SuiChain._(
        network: network,
        id: id,
        addressIndex: 0,
        client: client,
        addresses: []);
  }

  factory SuiChain.deserialize(
      {required WalletSuiNetwork network,
      required CborListValue cbor,
      SuiClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<ISuiAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => ISuiAddress.deserialize(network, obj: e))
        .toList();
    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return SuiChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  @override
  Future<void> _updateAddressBalanceInternal(ISuiAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      final balance = await client.getAcountBalances(address.networkAddress);
      final native = balance.firstWhereOrNull(
          (e) => e.coinType == SuiTransactionConst.suiTypeArgs);
      address._updateAddressBalance(native?.totalBalance ?? BigInt.zero);
      for (final token in address.tokens) {
        final asset =
            balance.firstWhereOrNull((e) => e.coinType == token.assetType);
        address._updateTokenBalance(token,
            () => token._updateBalance(asset?.totalBalance ?? BigInt.zero));
      }
    });
  }

  @override
  Future<void> updateTokenBalance(
      {required ISuiAddress address, required List<SuiToken> tokens}) async {
    _isAccountAddress(address);
    await onClient(onConnect: (client) async {
      final balance = await client.getAcountBalances(address.networkAddress);
      final native = balance.firstWhereOrNull(
          (e) => e.coinType == SuiTransactionConst.suiTypeArgs);
      address._updateAddressBalance(native?.totalBalance ?? BigInt.zero);
      for (final token in tokens) {
        final asset =
            balance.firstWhereOrNull((e) => e.coinType == token.assetType);
        address._updateTokenBalance(token,
            () => token._updateBalance(asset?.totalBalance ?? BigInt.zero));
      }
    });
  }

  @override
  ISuiAddress _deserializeAddress(List<int> adressBytes) {
    return ISuiAddress.deserialize(network, bytes: adressBytes);
  }
}
