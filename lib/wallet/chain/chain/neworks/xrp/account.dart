part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class XRPChainConfig extends DefaultNetworkConfig {
  XRPChainConfig()
      : super(supportToken: true, supportNft: true, supportWeb3: true);
}

final class XRPChain extends Chain<
    RippleAPIProvider,
    RippleNetworkParams,
    XRPAddress,
    RippleIssueToken,
    RippleNFToken,
    IXRPAddress,
    WalletXRPNetwork,
    XRPClient,
    XRPChainConfig,
    XRPWalletTransaction,
    RippleContact,
    RippleNewAddressParams> with XRPChainController {
  XRPChain._({
    required super.network,
    required super.addressIndex,
    required super.id,
    XRPChainConfig? config,
    required super.client,
    required super.addresses,
    super.totalBalance,
  }) : super._(config: config ?? XRPChainConfig());
  @override
  XRPChain copyWith({
    WalletXRPNetwork? network,
    List<ChainAccount>? addresses,
    List<ContactCore<XRPAddress>>? contacts,
    int? addressIndex,
    XRPClient? client,
    String? id,
    XRPChainConfig? config,
    BigInt? totalBalance,
  }) {
    return XRPChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<IXRPAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance.value.balance);
  }

  factory XRPChain.setup(
      {required WalletXRPNetwork network,
      required String id,
      XRPClient? client}) {
    return XRPChain._(
        network: network,
        id: id,
        addressIndex: 0,
        client: client,
        addresses: []);
  }

  factory XRPChain.deserialize(
      {required WalletXRPNetwork network,
      required CborListValue cbor,
      XRPClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<IXRPAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => IXRPAddress.deserialize(network, obj: e))
        .toList();
    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return XRPChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex < 0 ? 0 : addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  @override
  IXRPAddress? getAddress(String address) {
    return super.getAddress(address) ??
        _addresses
            .firstWhereOrNull((element) => element.baseAddress == address);
  }

  @override
  Future<void> _updateAddressBalanceInternal(IXRPAddress address,
      {bool tokens = true}) async {
    bool balanceChanged = false;
    await onClient(onConnect: (client) async {
      final balance = await client.getAccountBalance(address.networkAddress);
      balanceChanged |= await address._updateAddressBalance(balance);
      if (tokens) {
        final tokens = address.tokens;
        if (tokens.isEmpty) return;
        final balances = await client.getAccountTokens(address.networkAddress);
        for (final i in tokens) {
          final currentUpdate = balances.firstWhereOrNull((element) =>
              element.issuer.address == i.issuer &&
              element.currency == i.assetCode);
          balanceChanged |= await address._updateTokenBalance(
              i,
              () => i._updateBalance(
                  BigRational.parseDecimal(currentUpdate?.balance ?? "0")));
        }
      }
    });
    if (balanceChanged || true) _getAccountTxes(address);
  }

  @override
  Future<void> updateTokenBalance(
      {required IXRPAddress address,
      required List<RippleIssueToken> tokens}) async {
    _isAccountAddress(address);
    await onClient(onConnect: (client) async {
      if (tokens.isEmpty) return;
      final balances = await client.getAccountTokens(address.networkAddress);
      for (final i in tokens) {
        final currentUpdate = balances.firstWhereOrNull((element) =>
            element.issuer.address == i.issuer &&
            element.currency == i.assetCode);
        address._updateTokenBalance(
            i,
            () => i._updateBalance(
                BigRational.parseDecimal(currentUpdate?.balance ?? "0")));
      }
    });
  }

  @override
  IXRPAddress _deserializeAddress(List<int> adressBytes) {
    return IXRPAddress.deserialize(network, bytes: adressBytes);
  }
}
