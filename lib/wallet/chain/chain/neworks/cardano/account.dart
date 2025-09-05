part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class ADANetworkStorageId extends DefaultNetworkStorageId {
  static const ADANetworkStorageId utxos = ADANetworkStorageId(11);
  const ADANetworkStorageId(super.storageId);
  static const List<DefaultNetworkStorageId> values = [
    ...DefaultNetworkStorageId.values,
    utxos,
  ];
}

class ADANetworkConfig extends DefaultNetworkConfig<ADANetworkStorageId> {
  ADANetworkConfig(
      {super.supportToken = false,
      super.supportNft = false,
      super.supportWeb3 = true});

  @override
  List<DefaultNetworkStorageId> get storageKeys => ADANetworkStorageId.values;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([]), CborTagsConst.cardanoChainConfig);
  }
}

final class ADAChain extends Chain<
    CardanoAPIProvider,
    CardanoNetworkParams,
    ADAAddress,
    TokenCore,
    NFTCore,
    ICardanoAddress,
    WalletCardanoNetwork,
    ADAClient,
    ADANetworkConfig,
    ADAWalletTransaction,
    CardanoContact,
    BaseCardanoNewAddressParams> with ADAChainController {
  ADAChain._({
    required super.network,
    required super.addressIndex,
    required super.id,
    required super.config,
    required super.client,
    required super.addresses,
    super.totalBalance,
  }) : super._();
  @override
  ADAChain copyWith({
    WalletCardanoNetwork? network,
    List<ChainAccount>? addresses,
    int? addressIndex,
    ADAClient? client,
    String? id,
    ADANetworkConfig? config,
    BigInt? totalBalance,
  }) {
    return ADAChain._(
        network: network ?? this.network,
        addressIndex: addressIndex ?? _addressIndex,
        addresses: addresses?.cast<ICardanoAddress>() ?? _addresses,
        client: client ?? _client,
        id: id ?? this.id,
        config: config ?? this.config,
        totalBalance: totalBalance ?? this.totalBalance._value.balance);
  }

  factory ADAChain.setup(
      {required WalletCardanoNetwork network,
      required String id,
      ADAClient? client}) {
    return ADAChain._(
        network: network,
        addressIndex: 0,
        id: id,
        client: client,
        addresses: [],
        config: ADANetworkConfig());
  }

  factory ADAChain.deserialize(
      {required WalletCardanoNetwork network,
      required CborListValue cbor,
      ADAClient? client}) {
    final int networkId = cbor.elementAs(0);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String id = cbor.elementAs<String>(2);
    final List<ICardanoAddress> accounts = cbor
        .elementAsListOf<CborTagValue>(3)
        .map((e) => ICardanoAddress.deserialize(network, obj: e))
        .toList();
    final int addressIndex = cbor.elementAs(4);
    final BigInt? totalBalance = cbor.elementAs<BigInt?>(7);
    return ADAChain._(
        network: network,
        addresses: accounts,
        addressIndex: addressIndex,
        client: client,
        id: id,
        config: ADANetworkConfig(),
        totalBalance: totalBalance);
  }

  @override
  Future<void> updateTokenBalance(
      {required ICardanoAddress address,
      required List<TokenCore<BalanceCore<dynamic, APPToken>, APPToken>>
          tokens}) async {
    throw UnimplementedError();
  }

  @override
  ICardanoAddress _deserializeAddress(List<int> adressBytes) {
    return ICardanoAddress.deserialize(network, bytes: adressBytes);
  }
}
