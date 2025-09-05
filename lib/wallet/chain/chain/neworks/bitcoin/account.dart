part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class BitcoinNetworkStorageId extends DefaultNetworkStorageId {
  static const BitcoinNetworkStorageId utxos = BitcoinNetworkStorageId(11);
  const BitcoinNetworkStorageId(super.storageId);
  static const List<DefaultNetworkStorageId> values = [
    ...DefaultNetworkStorageId.values,
    utxos,
  ];
}

class BitcoinNetworkConfig
    extends DefaultNetworkConfig<BitcoinNetworkStorageId> {
  BitcoinNetworkConfig(
      {super.supportToken = false,
      super.supportNft = false,
      super.supportWeb3 = true});

  @override
  List<DefaultNetworkStorageId> get storageKeys =>
      BitcoinNetworkStorageId.values;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([]), CborTagsConst.bitcoinChainConfig);
  }
}

final class BitcoinChain extends Chain<
    BaseBitcoinAPIProvider,
    BitcoinParams,
    BitcoinBaseAddress,
    TokenCore,
    NFTCore,
    IBitcoinAddress,
    WalletBitcoinNetwork,
    BitcoinClient,
    BitcoinNetworkConfig,
    BitcoinWalletTransaction,
    BitcoinContact,
    BaseBitcoinNewAddressParams> with BitcoinChainController {
  BitcoinChain._({
    required super.network,
    required super.addressIndex,
    required super.id,
    BitcoinNetworkConfig? config,
    required super.client,
    required super.addresses,
    super.totalBalance,
  }) : super._(
            config: config ??
                BitcoinNetworkConfig(
                    supportNft: false, supportToken: false, supportWeb3: true));
  @override
  BitcoinChain copyWith({
    WalletBitcoinNetwork? network,
    List<ChainAccount>? addresses,
    int? addressIndex,
    BitcoinClient? client,
    String? id,
    BitcoinNetworkConfig? config,
    BigInt? totalBalance,
  }) {
    return BitcoinChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<IBitcoinAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance._value.balance);
  }

  factory BitcoinChain.setup(
      {required WalletBitcoinNetwork network,
      required String id,
      BitcoinClient? client}) {
    return BitcoinChain._(
        network: network,
        addressIndex: 0,
        id: id,
        client: client,
        addresses: []);
  }

  factory BitcoinChain.deserialize(
      {required WalletBitcoinNetwork network,
      required CborListValue cbor,
      BitcoinClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<IBitcoinAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => switch (network.type) {
              NetworkType.bitcoinAndForked =>
                IBitcoinAddress.deserialize(network, obj: e),
              NetworkType.bitcoinCash =>
                IBitcoinCashAddress.deserialize(network, obj: e),
              _ => throw WalletExceptionConst.invalidAccountDeta(
                  "BitcoinChain.deserialize")
            })
        .toList();
    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return BitcoinChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        totalBalance: totalBalance);
  }

  BitcoinBaseAddress? findAddressFromScript(Script script) {
    return _addresses
        .firstWhereOrNull((e) => e.networkAddress.toScriptPubKey() == script)
        ?.networkAddress;
  }

  @override
  Future<void> _updateAddressBalanceInternal(IBitcoinAddress address,
      {bool tokens = true}) async {
    await onClient(onConnect: (client) async {
      await getAccountUtxos(address);
    });
  }

  @override
  Future<void> updateTokenBalance(
      {required IBitcoinAddress address,
      required List<TokenCore<BalanceCore<dynamic, APPToken>, APPToken>>
          tokens}) async {}

  @override
  IBitcoinAddress _deserializeAddress(List<int> adressBytes) {
    return switch (network.type) {
      NetworkType.bitcoinAndForked =>
        IBitcoinAddress.deserialize(network, bytes: adressBytes),
      NetworkType.bitcoinCash =>
        IBitcoinCashAddress.deserialize(network, bytes: adressBytes),
      _ => throw WalletExceptionConst.invalidAccountDeta(
          "BitcoinChain.deserialize")
    };
  }
}
