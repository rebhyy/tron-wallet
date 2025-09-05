part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class StellarChain extends Chain<
    StellarAPIProvider,
    StellarNetworkParams,
    StellarAddress,
    StellarIssueToken,
    NFTCore,
    IStellarAddress,
    WalletStellarNetwork,
    StellarClient,
    DefaultNetworkConfig,
    StellarWalletTransaction,
    StellarContact,
    StellarNewAddressParams> {
  StellarChain._(
      {required super.network,
      required super.addressIndex,
      required super.id,
      DefaultNetworkConfig? config,
      required super.client,
      required super.addresses,
      super.totalBalance})
      : super._(config: config ?? DefaultNetworkConfig.defaultConfig);
  @override
  StellarChain copyWith({
    WalletStellarNetwork? network,
    List<ChainAccount>? addresses,
    int? addressIndex,
    StellarClient? client,
    String? id,
    DefaultNetworkConfig? config,
    BigInt? totalBalance,
  }) {
    return StellarChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<IStellarAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance._value.balance);
  }

  factory StellarChain.setup(
      {required WalletStellarNetwork network,
      required String id,
      StellarClient? client}) {
    return StellarChain._(
        network: network,
        id: id,
        addressIndex: 0,
        client: client,
        addresses: []);
  }

  factory StellarChain.deserialize(
      {required WalletStellarNetwork network,
      required CborListValue cbor,
      StellarClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<IStellarAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => IStellarAddress.deserialize(network, obj: e))
        .toList();

    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return StellarChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  @override
  Future<void> _updateAddressBalanceInternal(IStellarAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      final accountInfo = await client.getAccount(address.networkAddress);
      final balance = accountInfo?.balances
              .whereType<StellarNativeBalanceResponse>()
              .fold(BigInt.zero, (p, c) => p + c.unlockedBalance) ??
          BigInt.zero;
      address._updateAddressBalance(balance);
      for (final i in address.tokens) {
        final balance = accountInfo?.getAssetByIssueAsset(i);
        address._updateTokenBalance(
            i, () => i._updateBalance(balance?.unlockedBalance ?? BigInt.zero));
      }
    });
  }

  @override
  Future<void> updateTokenBalance(
      {required IStellarAddress address,
      required List<StellarIssueToken> tokens}) async {
    _isAccountAddress(address);
    await onClient(onConnect: (client) async {
      final accountInfo = await client.getAccount(address.networkAddress);
      final balance = accountInfo?.balances
              .whereType<StellarNativeBalanceResponse>()
              .fold(BigInt.zero, (p, c) => p + c.unlockedBalance) ??
          BigInt.zero;
      address._updateAddressBalance(balance);
      for (final i in tokens) {
        final balance = accountInfo?.getAssetByIssueAsset(i);
        address._updateTokenBalance(
            i, () => i._updateBalance(balance?.unlockedBalance ?? BigInt.zero));
      }
    });
  }

  @override
  IStellarAddress _deserializeAddress(List<int> adressBytes) {
    return IStellarAddress.deserialize(network, bytes: adressBytes);
  }
}
