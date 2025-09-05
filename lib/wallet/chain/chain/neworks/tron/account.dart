part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class TronNetworkStorageId extends DefaultNetworkStorageId {
  static const TronNetworkStorageId accountInfo = TronNetworkStorageId(11);
  static const TronNetworkStorageId accountResource = TronNetworkStorageId(12);
  const TronNetworkStorageId(super.storageId);

  static const List<DefaultNetworkStorageId> values = [
    ...DefaultNetworkStorageId.values,
    accountInfo,
    accountResource
  ];
}

class TronChainConfig extends DefaultNetworkConfig<TronNetworkStorageId> {
  TronChainConfig()
      : super(supportToken: true, supportNft: false, supportWeb3: true);
  @override
  List<DefaultNetworkStorageId> get storageKeys => TronNetworkStorageId.values;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([]), CborTagsConst.tronChainConfig);
  }
}

final class TronChain extends Chain<
    TronAPIProvider,
    TronNetworkParams,
    TronAddress,
    TronToken,
    NFTCore,
    ITronAddress,
    WalletTronNetwork,
    TronClient,
    TronChainConfig,
    TronWalletTransaction,
    TronContact,
    TronNewAddressParams> with TronChainRepository {
  TronChain._(
      {required super.network,
      required super.addressIndex,
      required super.id,
      TronChainConfig? config,
      required super.client,
      required super.addresses,
      super.totalBalance})
      : super._(config: config ?? TronChainConfig());
  @override
  TronChain copyWith(
      {WalletTronNetwork? network,
      List<ChainAccount>? addresses,
      int? addressIndex,
      TronClient? client,
      String? id,
      TronChainConfig? config,
      BigInt? totalBalance}) {
    return TronChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<ITronAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance.value.balance);
  }

  factory TronChain.setup(
      {required WalletTronNetwork network,
      required String id,
      TronClient? client}) {
    return TronChain._(
        network: network,
        addressIndex: 0,
        id: id,
        client: client,
        addresses: []);
  }
  factory TronChain.deserialize(
      {required WalletTronNetwork network,
      required CborListValue cbor,
      TronClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<ITronAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => ITronAddress.deserialize(network, obj: e))
        .toList();
    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return TronChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  @override
  Future<void> _updateAddressBalanceInternal(ITronAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      final balance = await client.getAccountInfo(address.networkAddress);
      final accountInfo = balance?.accountInfo;
      final accountResource = balance?.resource;
      address._updateTronAccount(accountInfo);
      address._updateAccountResource(accountResource);
      address._updateAddressBalance(accountInfo?.balance ?? BigInt.zero);
      if (tokens) {
        final tokens = address.tokens.whereType<SolidityToken>().toList();
        final balances = await Future.wait(tokens.map((e) async {
          try {
            return await client.solidityProvider.getTokenBalance(
                contract: e.contractAddress, address: address.networkAddress);
          } catch (e) {
            return null;
          }
        }));
        for (int i = 0; i < tokens.length; i++) {
          final token = tokens[i];
          final balance = balances[i];
          if (balance == null) continue;
          address._updateTokenBalance(
              token as TronToken, () => token._updateBalance(balance));
        }
      }
    });
  }

  @override
  ITronAddress? getAddress(String address) {
    return super.getAddress(address) ??
        _addresses
            .firstWhereOrNull((element) => element.baseAddress == address);
  }

  @override
  Future<void> updateTokenBalance(
      {required ITronAddress address, required List<TronToken> tokens}) async {
    _isAccountAddress(address);
    await onClient(onConnect: (client) async {
      final trc10Tokens = tokens.where((e) => e.tronTokenType.isTrc10);
      if (trc10Tokens.isNotEmpty) {
        final balance = await client.getAccountInfo(address.networkAddress);
        final accountInfo = balance?.accountInfo;
        final accountResource = balance?.resource;
        address._updateTronAccount(accountInfo);
        address._updateAccountResource(accountResource);
        for (final i in trc10Tokens) {
          final balance =
              accountInfo?.assetV2.firstWhereNullable((e) => i.issuer == e.key);
          i._updateBalance(balance?.value ?? BigInt.zero);
        }
      }
      final trc20Tokens = tokens.whereType<SolidityToken>().toList();
      final balances = await Future.wait(trc20Tokens.map((e) async {
        try {
          return await client.solidityProvider.getTokenBalance(
              contract: e.contractAddress, address: address.networkAddress);
        } catch (e) {
          return null;
        }
      }));
      for (int i = 0; i < trc20Tokens.length; i++) {
        final token = trc20Tokens[i];
        final balance = balances[i];
        if (balance == null) continue;
        address._updateTokenBalance(
            token as TronToken, () => token._updateBalance(balance));
      }
    });
  }

  // @override
  // Future<void> _initAddress(ITronAddress? address) async {
  //   if (address == null || !address._status.isInit) return;
  //   await super._initAddress(address);
  //   final resource = await _getTronAccountResource(address);
  //   address._setAccountResource(resource);
  //   final accountInfo = await _getTronAccountInfo(address);
  //   address._setTronAccount(accountInfo);
  // }

  @override
  ITronAddress _deserializeAddress(List<int> adressBytes) {
    return ITronAddress.deserialize(network, bytes: adressBytes);
  }
}
