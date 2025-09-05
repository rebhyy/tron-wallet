part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class IBitcoinCashAddress extends IBitcoinAddress {
  IBitcoinCashAddress._(
      {required super.keyIndex,
      required super.coin,
      required super.publicKey,
      required super.networkAddress,
      required super.address,
      required super.addressType,
      required super.network,
      required super.keyType,
      required super.identifier,
      super.accountName})
      : super();

  factory IBitcoinCashAddress._newAccount(
      {required List<int> publicKey,
      required WalletBitcoinCashNetwork network,
      required CryptoCoins coin,
      required BitcoinAddressType addressType,
      required PubKeyModes pubkeyMode,
      required AddressDerivationIndex keyIndex,
      required BitcoinBaseAddress address,
      required String identifier}) {
    final transactionNetwork = network.coinParam.transacationNetwork;
    if (transactionNetwork is! BitcoinCashNetwork) {
      throw WalletExceptionConst.invalidAccountDeta(
          "IBitcoinCashAddress._newAccount");
    }
    final balance = ChainAccountBalance(
        address: address.toAddress(transactionNetwork), network: network);
    return IBitcoinCashAddress._(
        coin: coin,
        publicKey: publicKey,
        address: balance,
        keyIndex: keyIndex,
        networkAddress: address,
        addressType: addressType,
        network: network.value,
        keyType: pubkeyMode,
        identifier: identifier);
  }

  factory IBitcoinCashAddress.deserialize(WalletBitcoinNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborTagValue toCborTag =
        CborSerializable.decode(cborBytes: bytes, object: obj);
    if (BytesUtils.bytesEqual(
        toCborTag.tags, CborTagsConst.bitcoinCashMultiSigAccount)) {
      return IBitcoinCashMultiSigAddress.deserialize(network, obj: toCborTag);
    }
    final CborListValue cbor = CborSerializable.cborTagValue(
        object: toCborTag, tags: CborTagsConst.bitcoinCashAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(cbor.elementAs(0));
    final keyIndex =
        AddressDerivationIndex.deserialize(obj: cbor.elementAsCborTag(1));
    final List<int> publicKey = cbor.elementAs(2);
    final ChainAccountBalance address =
        ChainAccountBalance.deserialize(network, obj: cbor.elementAsCborTag(3));
    final BitcoinAddressType bitcoinAddressType =
        BitcoinAddressType.fromValue(cbor.elementAs(4));
    final int networkId = cbor.elementAs(5);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String? name = cbor.elementAs(6);

    final keyType = PubKeyModes.fromValue(cbor.elementAs(7),
        defaultValue: PubKeyModes.compressed);
    final btcNetwork = network.coinParam.transacationNetwork;
    final bitcoinAddress = BlockchainAddressUtils.toBitcoinAddress(
        address.toAddress, btcNetwork,
        p2shAddressType: bitcoinAddressType);
    if (bitcoinAddress.toAddress(btcNetwork) != address.toAddress ||
        bitcoinAddress.type != bitcoinAddressType) {
      throw WalletExceptionConst.invalidAccountDeta(
          "IBitcoinCashAddress.deserialize");
    }
    final String identifier = cbor.elementAs(8);

    return IBitcoinCashAddress._(
        coin: coin,
        publicKey: publicKey,
        address: address,
        keyIndex: keyIndex,
        networkAddress: bitcoinAddress,
        addressType: bitcoinAddressType,
        network: network.value,
        accountName: name,
        keyType: keyType,
        identifier: identifier);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          keyIndex.toCbor(),
          publicKey,
          address.toCbor(),
          addressType.value,
          network,
          accountName ?? const CborNullValue(),
          keyType.value,
          identifier
        ]),
        CborTagsConst.bitcoinCashAccount);
  }

  @override
  String get type => addressType.value;

  // @override
  @override
  String get baseAddress => networkAddress.addressProgram;

  @override
  NewAccountParams toAccountParams() {
    return BitcoinCashNewAddressParams(
        deriveIndex: keyIndex,
        bitcoinAddressType: addressType,
        coin: coin,
        keyType: keyType);
  }
}

final class IBitcoinCashMultiSigAddress extends IBitcoinCashAddress
    with BitcoinMultiSigBase
    implements MultiSigCryptoAccountAddress {
  factory IBitcoinCashMultiSigAddress._newAccount({
    required WalletBitcoinCashNetwork network,
    required CryptoCoins coin,
    required BitcoinBaseAddress address,
    required BitcoinMultiSignatureAddress multiSignatureAddress,
    required BitcoinAddressType addressType,
    required String identifier,
  }) {
    final transactionNetwork = network.coinParam.transacationNetwork;
    if (transactionNetwork is! BitcoinCashNetwork) {
      throw WalletExceptionConst.invalidAccountDeta(
          "IBitcoinCashAddress._newAccount");
    }
    final balance = ChainAccountBalance(
        address: address.toAddress(transactionNetwork), network: network);
    return IBitcoinCashMultiSigAddress._(
        coin: coin,
        address: balance,
        multiSignatureAddress: multiSignatureAddress,
        networkAddress: address,
        addressType: addressType,
        network: network.value,
        keyIndex: MultiSigAddressIndex(),
        identifier: identifier);
  }

  factory IBitcoinCashMultiSigAddress.deserialize(WalletNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CborTagsConst.bitcoinCashMultiSigAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final BitcoinMultiSignatureAddress multiSignatureAddress =
        BitcoinMultiSignatureAddress.deserialize(
            obj: values.elementAsCborTag(1));
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(2));
    final BitcoinAddressType bitcoinAddressType =
        BitcoinAddressType.fromValue(values.elementAs(3));
    final int networkId = values.elementAs(4);

    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final keyIndex =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(5));

    final bitcoinAddress = BlockchainAddressUtils.toBitcoinAddress(
        address.toAddress,
        (network as WalletBitcoinNetwork).coinParam.transacationNetwork,
        p2shAddressType: bitcoinAddressType);
    if (bitcoinAddressType != bitcoinAddress.type) {
      throw WalletExceptionConst.invalidAccountDeta(
          "IBitcoinCashMultiSigAddress.deserialize");
    }
    final String? name = values.elementAs(6);
    final String identifier = values.elementAs(7);
    return IBitcoinCashMultiSigAddress._(
        coin: coin,
        address: address,
        networkAddress: bitcoinAddress,
        addressType: bitcoinAddressType,
        multiSignatureAddress: multiSignatureAddress,
        network: network.value,
        keyIndex: keyIndex,
        accountName: name,
        identifier: identifier);
  }
  IBitcoinCashMultiSigAddress._(
      {required super.coin,
      required super.networkAddress,
      required super.address,
      required super.addressType,
      required this.multiSignatureAddress,
      required super.network,
      required super.keyIndex,
      required super.identifier,
      super.accountName})
      : super._(publicKey: const [], keyType: PubKeyModes.compressed);

  @override
  List<int> get publicKey =>
      throw WalletExceptionConst.featureUnavailableForMultiSignature;

  @override
  PubKeyModes get keyType =>
      throw WalletExceptionConst.featureUnavailableForMultiSignature;

  @override
  final BitcoinMultiSignatureAddress multiSignatureAddress;
  @override
  Script? witnessScript() {
    return null;
  }

  @override
  Script? redeemScript() {
    if (!addressType.isP2sh) return null;
    switch (addressType) {
      case P2shAddressType.p2pkInP2sh:
      case P2shAddressType.p2pkInP2sh32:
      case P2shAddressType.p2pkInP2shwt:
      case P2shAddressType.p2pkInP2sh32wt:
      case P2shAddressType.p2pkhInP2sh:
      case P2shAddressType.p2pkhInP2sh32:
      case P2shAddressType.p2pkhInP2shwt:
      case P2shAddressType.p2pkhInP2sh32wt:
        return multiSignatureAddress.multiSigScript;
      default:
        return null;
    }
  }

  late final UtxoAddressDetails _toUtxoRequest =
      UtxoAddressDetails.multiSigAddress(
          multiSigAddress: multiSignatureAddress, address: networkAddress);
  @override
  UtxoAddressDetails get toUtxoRequest => _toUtxoRequest;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          multiSignatureAddress.toCbor(),
          address.toCbor(),
          addressType.value,
          network,
          keyIndex.toCbor(),
          accountName ?? const CborNullValue(),
          identifier
        ]),
        CborTagsConst.bitcoinCashMultiSigAccount);
  }

  @override
  List get variabels => [
        addressType,
        keyIndex,
        network,
        multiSignatureAddress.multiSigScript.toHex()
      ];

  @override
  List<String> get signers =>
      multiSignatureAddress.signers.map((e) => e.publicKey).toList();

  @override
  List<AddressDerivationIndex> signerKeyIndexes() {
    return multiSignatureAddress.signers.map((e) => e.keyIndex).toList();
  }

  @override
  String get baseAddress => networkAddress.addressProgram;

  @override
  NewAccountParams toAccountParams() {
    return BitcoinCashMultiSigNewAddressParams(
        multiSignatureAddress: multiSignatureAddress,
        bitcoinAddressType: addressType,
        coin: coin);
  }

  @override
  IAdressType get iAddressType => IAdressType.multisigByPublicKey;
}
