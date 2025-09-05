part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

abstract final class BaseCardanoNewAddressParams
    extends NewAccountParams<ICardanoAddress> {
  final ADAAddressType addressType;
  const BaseCardanoNewAddressParams._({required this.addressType}) : super._();
}

final class CardanoNewAddressParams extends BaseCardanoNewAddressParams {
  @override
  final AddressDerivationIndex deriveIndex;
  final AddressDerivationIndex? rewardKeyIndex;
  final CardanoAddrDetails? addressDetails;
  final String? customHdPath;
  final List<int>? customHdPathKey;
  bool get needStakeKey => addressType == ADAAddressType.base;
  @override
  bool get isMultiSig => false;
  @override
  final CryptoCoins coin;
  CardanoNewAddressParams._(
      {required super.addressType,
      required this.deriveIndex,
      required this.rewardKeyIndex,
      required this.coin,
      this.addressDetails,
      this.customHdPath,
      List<int>? customHdPathKey})
      : customHdPathKey =
            BytesUtils.tryToBytes(customHdPathKey, unmodifiable: true),
        super._();
  factory CardanoNewAddressParams(
      {required ADAAddressType addressType,
      required AddressDerivationIndex deriveIndex,
      required AddressDerivationIndex? rewardKeyIndex,
      required CryptoCoins coin,
      CardanoAddrDetails? addressDetails,
      String? customHdPath,
      List<int>? customHdPathKey}) {
    return CardanoNewAddressParams._(
        addressType: addressType,
        deriveIndex: deriveIndex,
        rewardKeyIndex: rewardKeyIndex,
        coin: coin,
        addressDetails: addressDetails,
        customHdPath: customHdPath,
        customHdPathKey: customHdPathKey);
  }

  factory CardanoNewAddressParams.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: NewAccountParamsType.cardanoNewAddressParams.tag);
    return CardanoNewAddressParams(
        addressType: ADAAddressType.fromHeader(values.elementAs(0)),
        deriveIndex:
            AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(1)),
        rewardKeyIndex: values.elemetMybeAs<Bip32AddressIndex, CborObject>(
            2, (e) => Bip32AddressIndex.deserialize(obj: e)),
        addressDetails: values.elemetMybeAs<CardanoAddrDetails, CborObject>(
            3, (e) => CardanoAddrDetails.deserialize(obj: e)),
        customHdPath: values.elementAs(4),
        customHdPathKey: values.elementAs(5),
        coin: CustomCoins.getSerializationCoin(values.elementAs(6)));
  }
  CardanoNewAddressParams copyWith(
      {ADAAddressType? addressType,
      AddressDerivationIndex? deriveIndex,
      CardanoAddrDetails? addressDetails,
      AddressDerivationIndex? rewardKeyIndex,
      List<int>? publicKey,
      String? customHdPath,
      List<int>? customHdPathKey,
      CryptoCoins? coin}) {
    return CardanoNewAddressParams(
        addressType: addressType ?? this.addressType,
        deriveIndex: deriveIndex ?? this.deriveIndex,
        addressDetails: addressDetails ?? this.addressDetails,
        rewardKeyIndex: rewardKeyIndex ?? this.rewardKeyIndex,
        customHdPath: customHdPath,
        customHdPathKey: customHdPathKey,
        coin: coin ?? this.coin);
  }

  @override
  ICardanoAddress toAccount(
      WalletNetwork network, CryptoPublicKeyData? publicKey) {
    if (publicKey == null) {
      throw WalletExceptionConst.pubkeyRequired;
    }
    final addressDetails = this.addressDetails;
    if (addressDetails == null) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoNewAddressParams.toAccount");
    }
    if (network is! WalletCardanoNetwork) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoNewAddressParams.toAccount");
    }
    if (needStakeKey && rewardKeyIndex == null) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoNewAddressParams.toAccount");
    }
    final address = addressDetails.toAddress(network.coinParam.networkType);
    return ICardanoAddress._newAccount(
        publicKey: addressDetails.publicKey,
        network: network,
        address: address,
        addressInfo: addressDetails,
        coin: coin,
        keyIndex: deriveIndex,
        rewardIndex: rewardKeyIndex,
        identifier: NewAccountParams.toIdentifier(address.address));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          addressType.header,
          deriveIndex.toCbor(),
          rewardKeyIndex?.toCbor(),
          addressDetails?.toCbor(),
          customHdPath,
          customHdPathKey == null
              ? const CborNullValue()
              : CborBytesValue(customHdPathKey!),
          coin.toCbor()
        ]),
        type.tag);
  }

  @override
  NewAccountParamsType get type => NewAccountParamsType.cardanoNewAddressParams;
}

final class CardanoMultisigNewAddressParams
    extends BaseCardanoNewAddressParams {
  @override
  final AddressDerivationIndex deriveIndex = MultiSigAddressIndex();
  final CardanoMultiSignatureAddressDetails addressInfo;
  bool get needStakeKey => addressType == ADAAddressType.base;
  @override
  bool get isMultiSig => true;
  @override
  final CryptoCoins coin;
  CardanoMultisigNewAddressParams._(
      {required this.addressInfo, required this.coin})
      : super._(addressType: addressInfo.addressType);
  factory CardanoMultisigNewAddressParams(
      {required CardanoMultiSignatureAddressDetails addressInfo,
      required CryptoCoins coin}) {
    return CardanoMultisigNewAddressParams._(
        addressInfo: addressInfo, coin: coin);
  }

  factory CardanoMultisigNewAddressParams.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: NewAccountParamsType.cardanoMultisigNewAddressParams.tag);
    return CardanoMultisigNewAddressParams(
        coin: CustomCoins.getSerializationCoin(values.valueAs(0)),
        addressInfo: CardanoMultiSignatureAddressDetails.deserialize(
            obj: values.indexAs<CborTagValue>(1)));
  }

  @override
  ICardanoAddress toAccount(
      WalletNetwork network, CryptoPublicKeyData? publicKey) {
    if (network is! WalletCardanoNetwork) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoMultisigNewAddressParams.toAccount");
    }
    final address = addressInfo.toAddress(network.coinParam.networkType);
    return ICardanoMultiSigAddress._newAccount(
        network: network,
        address: address,
        addressInfo: addressInfo,
        coin: coin,
        identifier: NewAccountParams.toIdentifier(address.address));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([coin.toCbor(), addressInfo.toCbor()]),
        type.tag);
  }

  @override
  NewAccountParamsType get type =>
      NewAccountParamsType.cardanoMultisigNewAddressParams;
}
