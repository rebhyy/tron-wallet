part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class IEthAddress extends ChainAccount<ETHAddress, ETHERC20Token, NFTCore,
    EthWalletTransaction> {
  IEthAddress._(
      {required super.keyIndex,
      required super.coin,
      required super.address,
      required super.network,
      required super.networkAddress,
      required super.identifier,
      required List<int> publicKey,
      super.accountName})
      : publicKey = publicKey.asImmutableBytes;

  factory IEthAddress._newAccount({
    required List<int> publicKey,
    required WalletEthereumNetwork network,
    required CryptoCoins coin,
    required ETHAddress address,
    required String identifier,
    required AddressDerivationIndex keyIndex,
  }) {
    final balance =
        ChainAccountBalance(address: address.address, network: network);
    return IEthAddress._(
        coin: coin,
        address: balance,
        keyIndex: keyIndex,
        networkAddress: address,
        network: network.value,
        publicKey: publicKey,
        identifier: identifier);
  }

  factory IEthAddress.deserialize(WalletEthereumNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.ethAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final keyIndex =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(1));
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(2));
    final ETHAddress ethAddress = ETHAddress(address.toAddress);
    final int networkId = values.elementAs(3);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }

    final String? accountName = values.elementAs(4);
    final List<int> publicKey = values.elementAs(5);
    final String identifier = values.elementAs(6);
    return IEthAddress._(
        coin: coin,
        address: address,
        keyIndex: keyIndex,
        networkAddress: ethAddress,
        network: networkId,
        accountName: accountName,
        publicKey: publicKey,
        identifier: identifier);
  }

  @override
  final List<int> publicKey;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          keyIndex.toCbor(),
          address.toCbor(),
          network,
          accountName ?? const CborNullValue(),
          CborBytesValue(publicKey),
          identifier
        ]),
        CborTagsConst.ethAccount);
  }

  @override
  List get variabels {
    return [keyIndex, network];
  }

  @override
  String? get type => null;

  @override
  EthereumNewAddressParams toAccountParams() {
    return EthereumNewAddressParams(deriveIndex: keyIndex, coin: coin);
  }
}
