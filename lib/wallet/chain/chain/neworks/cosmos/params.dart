part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class CosmosNewAddressParams extends NewAccountParams<ICosmosAddress> {
  @override
  bool get isMultiSig => false;
  @override
  final CryptoCoins coin;

  @override
  final AddressDerivationIndex deriveIndex;

  final CosmosKeysAlgs algorithm;

  const CosmosNewAddressParams._(
      {required this.deriveIndex, required this.coin, required this.algorithm})
      : super._();
  factory CosmosNewAddressParams(
      {required AddressDerivationIndex deriveIndex,
      required CryptoCoins coin,
      required CosmosKeysAlgs algorithm}) {
    return CosmosNewAddressParams._(
        deriveIndex: deriveIndex, coin: coin, algorithm: algorithm);
  }
  factory CosmosNewAddressParams.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: NewAccountParamsType.cosmosNewAddressParams.tag);
    return CosmosNewAddressParams(
        deriveIndex:
            AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(0)),
        coin: CustomCoins.getSerializationCoin(values.elementAs(1)),
        algorithm: CosmosKeysAlgs.fromName(values.elementAs(2)));
  }

  CosmosPublicKey toPublicKey(List<int> publicKey) {
    return CosmosPublicKey.fromBytes(keyBytes: publicKey, algorithm: algorithm);
  }

  @override
  ICosmosAddress toAccount(
      WalletNetwork network, CryptoPublicKeyData? publicKey) {
    if (publicKey == null) {
      throw WalletExceptionConst.pubkeyRequired;
    }
    if (network is! WalletCosmosNetwork) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CosmosNewAddressParams.toAccount");
    }
    final publickKeyBytes =
        publicKey.normalizedComprossedBytes.asImmutableBytes;
    final address = CosmosBaseAddress.fromPublicKey(
        pubkeyBytes: publickKeyBytes,
        algorithm: algorithm,
        hrp: network.coinParam.hrp);
    return ICosmosAddress._newAccount(
        publicKey: publickKeyBytes,
        network: network,
        address: address,
        keyIndex: deriveIndex,
        algorithm: algorithm,
        coin: coin,
        identifier: NewAccountParams.toIdentifier(address.address));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [deriveIndex.toCbor(), coin.toCbor(), algorithm.name]),
        type.tag);
  }

  @override
  NewAccountParamsType get type => NewAccountParamsType.cosmosNewAddressParams;
}
