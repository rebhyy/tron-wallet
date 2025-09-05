part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class EthereumChain extends Chain<
    EthereumAPIProvider,
    EthereumNetworkParams,
    ETHAddress,
    ETHERC20Token,
    NFTCore,
    IEthAddress,
    WalletEthereumNetwork,
    EthereumClient,
    DefaultNetworkConfig,
    EthWalletTransaction,
    EthereumContact,
    EthereumNewAddressParams> {
  EthereumChain._(
      {required super.network,
      required super.addressIndex,
      required super.id,
      DefaultNetworkConfig? config,
      required super.addresses,
      required super.client,
      super.totalBalance})
      : super._(config: config ?? DefaultNetworkConfig.defaultConfig);
  @override
  EthereumChain copyWith(
      {WalletEthereumNetwork? network,
      List<ChainAccount>? addresses,
      int? addressIndex,
      EthereumClient? client,
      String? id,
      DefaultNetworkConfig? config,
      BigInt? totalBalance}) {
    return EthereumChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<IEthAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance._value.balance);
  }

  factory EthereumChain.setup(
      {required WalletEthereumNetwork network,
      required String id,
      EthereumClient? client}) {
    return EthereumChain._(
        network: network,
        id: id,
        addressIndex: 0,
        client: client,
        addresses: []);
  }

  factory EthereumChain.deserialize(
      {required WalletEthereumNetwork network,
      required CborListValue cbor,
      EthereumClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<IEthAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => IEthAddress.deserialize(network, obj: e))
        .toList();

    int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs(7);
    return EthereumChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  BigInt get chainId => network.coinParam.chainId;

  @override
  Future<void> _updateAddressBalanceInternal(IEthAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      final balance = await client.getBalance(address.networkAddress);
      address._updateAddressBalance(balance);
      if (tokens) {
        final tokens = address.tokens;
        final balances = await Future.wait(tokens.map((e) async {
          try {
            final balance = await client.getTokenBalance(
                address: address.networkAddress, contract: e.contractAddress);
            return balance;
          } catch (_) {
            return null;
          }
        }));
        for (int i = 0; i < tokens.length; i++) {
          final token = tokens[i];
          final balance = balances[i];
          if (balance == null) continue;
          address._updateTokenBalance(
              token, () => token._updateBalance(balance));
        }
      }
    });
  }

  @override
  Future<void> updateTokenBalance(
      {required IEthAddress address,
      required List<ETHERC20Token> tokens}) async {
    _isAccountAddress(address);
    await onClient(onConnect: (client) async {
      final balances = await Future.wait(tokens.map((e) async {
        try {
          final balance = await client.getTokenBalance(
              address: address.networkAddress, contract: e.contractAddress);
          return balance;
        } catch (_) {
          return null;
        }
      }));
      for (int i = 0; i < tokens.length; i++) {
        final token = tokens[i];
        final balance = balances[i];
        if (balance == null) continue;
        address._updateTokenBalance(token, () => token._updateBalance(balance));
      }
    });
  }

  @override
  IEthAddress _deserializeAddress(List<int> adressBytes) {
    return IEthAddress.deserialize(network, bytes: adressBytes);
  }
}
