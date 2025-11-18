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
  @override
  List<DefaultNetworkStorageId> get storageKeys => TronNetworkStorageId.values;

  TronChainConfig(
      {super.supportToken = true,
      super.supportNft = false,
      super.supportWeb3 = true,
      super.enableProvider = true});
  factory TronChainConfig.deserialize(
      {List<int>? cborBytes, String? cborHex, CborObject? cborObject}) {
    final values = CborSerializable.cborTagValue(
        cborBytes: cborBytes, hex: cborHex, object: cborObject);
    return TronChainConfig(
      supportToken: values.valueAs<bool?>(0) ?? true,
      supportNft: values.valueAs<bool?>(1) ?? false,
      supportWeb3: values.valueAs<bool?>(2) ?? true,
      enableProvider: values.valueAs<bool?>(3) ?? true,
    );
  }
  @override
  TronChainConfig copyWith(
      {bool? supportToken,
      bool? supportNft,
      bool? supportWeb3,
      bool? enableProvider}) {
    return TronChainConfig(
        supportToken: supportToken ?? this.supportToken,
        supportNft: supportNft ?? this.supportNft,
        supportWeb3: supportWeb3 ?? this.supportWeb3,
        enableProvider: enableProvider ?? this.enableProvider);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          supportToken,
          supportNft,
          supportWeb3,
          enableProvider,
        ]),
        CborTagsConst.tronChainConfig);
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
      required super.config,
      required super.service,
      required super.addresses,
      super.totalBalance})
      : super._();
  @override
  TronChain copyWith(
      {WalletTronNetwork? network,
      List<ChainAccount>? addresses,
      int? addressIndex,
      ProviderIdentifier? service,
      String? id,
      TronChainConfig? config,
      BigInt? totalBalance}) {
    return TronChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<ITronAddress>() ?? _addresses,
        service: service ?? _serviceIdentifier,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance.value.balance);
  }

  factory TronChain.setup(
      {required WalletTronNetwork network,
      required String id,
      ProviderIdentifier? service}) {
    return TronChain._(
        network: network,
        addressIndex: 0,
        id: id,
        service: service,
        addresses: [],
        config: TronChainConfig());
  }

  List<TronTRC20Token> _defaultStableTokens(WalletTronNetwork network) {
    if (network.tronNetworkType != TronChainType.mainnet) return const [];
    return const [
      (
        "Tether USD",
        "USDT",
        6,
        "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t",
      ),
      (
        "USD Coin",
        "USDC",
        6,
        "TEkxiTehnzSmSe2XqrBj4w32RUN966rdz8",
      ),
    ]
        .map((e) => TronTRC20Token.create(
            balance: BigInt.zero,
            token: Token(name: e.$1, symbol: e.$2, decimal: e.$3),
            contractAddress: TronAddress(e.$4)))
        .toList();
  }

  @override
  Future<ITronAddress> addNewAddress(
      CryptoPublicKeyData? publicKey, TronNewAddressParams accountParams) async {
    final address = await super.addNewAddress(publicKey, accountParams);
    final defaults = _defaultStableTokens(network);
    for (final token in defaults) {
      final exists = address.tokens.any(
          (t) => t is TronTRC20Token && t.contractAddress == token.contractAddress);
      if (!exists) {
        await address._addToken(token);
      }
    }
    return address;
  }

  Future<void> _ensureDefaultStableTokensForExistingAddresses() async {
    final defaults = _defaultStableTokens(network);
    if (defaults.isEmpty || _addresses.isEmpty) return;
    for (final address in _addresses) {
      for (final token in defaults) {
        final exists = address.tokens.any((t) =>
            t is TronTRC20Token &&
            t.contractAddress == token.contractAddress);
        if (!exists) {
          await address._addToken(token);
        }
      }
    }
  }

  @override
  Future<void> init({bool client = true}) async {
    await super.init(client: client);
    await _ensureDefaultStableTokensForExistingAddresses();
  }

  factory TronChain.deserialize(
      {required WalletTronNetwork network, required CborListValue cbor}) {
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
    final TronChainConfig config =
        TronChainConfig.deserialize(cborObject: cbor.indexAs(5));
    final ProviderIdentifier? service = MethodUtils.nullOnException(() {
      final CborTagValue? identifier = cbor.elementAs(6);
      if (identifier == null) return null;
      return ProviderIdentifier.deserialize(cbor: identifier);
    });
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return TronChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        service: service,
        id: id,
        totalBalance: totalBalance,
        config: config);
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
