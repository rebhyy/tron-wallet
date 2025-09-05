part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class TonChain extends Chain<
    TonAPIProvider,
    TonNetworkParams,
    TonAddress,
    TonJettonToken,
    NFTCore,
    ITonAddress,
    WalletTonNetwork,
    TonClient,
    DefaultNetworkConfig,
    TonWalletTransaction,
    TonContact,
    TonNewAddressParams> {
  TonChain._({
    required super.network,
    required super.addressIndex,
    required super.id,
    DefaultNetworkConfig? config,
    required super.client,
    required super.addresses,
    super.totalBalance,
  }) : super._(config: config ?? DefaultNetworkConfig.defaultConfig);
  @override
  TonChain copyWith({
    WalletTonNetwork? network,
    List<ChainAccount>? addresses,
    List<ContactCore<TonAddress>>? contacts,
    int? addressIndex,
    TonClient? client,
    String? id,
    DefaultNetworkConfig? config,
    BigInt? totalBalance,
  }) {
    return TonChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<ITonAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance.value.balance);
  }

  factory TonChain.setup(
      {required WalletTonNetwork network,
      required String id,
      TonClient? client}) {
    return TonChain._(
        network: network,
        id: id,
        addressIndex: 0,
        client: client,
        addresses: []);
  }

  factory TonChain.deserialize(
      {required WalletTonNetwork network,
      required CborListValue cbor,
      TonClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<ITonAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => ITonAddress.deserialize(network, obj: e))
        .toList();
    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return TonChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  @override
  Future<void> _updateAddressBalanceInternal(ITonAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      final balance = await client.getAccountBalance(address.networkAddress);
      address._updateAddressBalance(balance);
      if (tokens) {
        final tokens = address.tokens;
        final balances = await Future.wait(tokens.map((e) async {
          try {
            return await client.getJettonWalletData(e.walletAddress);
          } catch (_) {
            return null;
          }
        }));
        for (int i = 0; i < tokens.length; i++) {
          final token = tokens[i];
          final balance = balances[i];
          if (balance == null) continue;
          address._updateTokenBalance(
              token, () => token._updateBalance(balance.balance));
        }
      }
    });
  }

  @override
  Future<void> updateTokenBalance(
      {required ITonAddress address,
      required List<TonJettonToken> tokens}) async {
    _isAccountAddress(address);
    await onClient(onConnect: (client) async {
      final balances = await Future.wait(tokens.map((e) async {
        try {
          return await client.getJettonWalletData(e.walletAddress);
        } catch (_) {
          return null;
        }
      }));
      for (int i = 0; i < tokens.length; i++) {
        final token = tokens[i];
        final balance = balances[i];
        if (balance == null) continue;
        address._updateTokenBalance(
            token, () => token._updateBalance(balance.balance));
      }
    });
  }

  @override
  ITonAddress _deserializeAddress(List<int> adressBytes) {
    return ITonAddress.deserialize(network, bytes: adressBytes);
  }
}
