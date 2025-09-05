part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

enum XrpAddressType {
  xAddress("x_address"),
  classic("classic_address");

  final String value;
  const XrpAddressType(this.value);
}

final class IXRPAddress extends ChainAccount<XRPAddress, RippleIssueToken,
    RippleNFToken, XRPWalletTransaction> {
  final XrpAddressType addressType;
  final int? tag;
  int? _lastUpdateLedgerIndex;

  IXRPAddress._(
      {required super.keyIndex,
      required super.coin,
      required List<int> publicKey,
      required super.address,
      required super.network,
      required super.networkAddress,
      required this.tag,
      required super.identifier,
      super.accountName,
      int? lastUpdateLedgerIndex})
      : publicKey = List.unmodifiable(publicKey),
        addressType =
            tag == null ? XrpAddressType.classic : XrpAddressType.xAddress,
        _lastUpdateLedgerIndex = lastUpdateLedgerIndex;
  factory IXRPAddress._newAccount(
      {required CryptoCoins coin,
      required int? tag,
      required XRPAddress address,
      required AddressDerivationIndex keyIndex,
      required List<int> publicKey,
      required WalletXRPNetwork network,
      required String identifier}) {
    final addressDetails =
        ChainAccountBalance(address: address.toAddress(), network: network);
    return IXRPAddress._(
        coin: coin,
        publicKey: publicKey,
        address: addressDetails,
        keyIndex: keyIndex,
        networkAddress: address,
        network: network.value,
        tag: tag,
        identifier: identifier);
  }
  factory IXRPAddress.deserialize(WalletNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborTagValue cborTag =
        CborSerializable.decode(cborBytes: bytes, object: obj);
    if (BytesUtils.bytesEqual(
        cborTag.tags, CborTagsConst.rippleMultisigAccount)) {
      return IXRPMultisigAddress.deserialize(network, obj: cborTag);
    }
    final CborListValue values = CborSerializable.cborTagValue(
        object: cborTag, tags: CborTagsConst.rippleAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.valueAs(0));
    final keyIndex =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(1));
    final List<int> publicKey = values.valueAs(2);
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(3));
    final XRPAddress rippleAddress = XRPAddress(address.toAddress);
    final int? tag = values.valueAs(4);
    final networkId = values.valueAs(5);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String? accountName = values.valueAs(6);
    final String identifier = values.valueAs(7);
    final int? lastUpdateLedgerIndex = values.valueAs(8);
    return IXRPAddress._(
        coin: coin,
        publicKey: publicKey,
        address: address,
        keyIndex: keyIndex,
        networkAddress: rippleAddress,
        network: networkId,
        tag: tag,
        accountName: accountName,
        identifier: identifier,
        lastUpdateLedgerIndex: lastUpdateLedgerIndex);
  }

  XRPPublicKey toXRPPublicKey() {
    final algorithm = XRPKeyAlgorithm.values.firstWhere(
        (element) => element.curveType == keyIndex.currencyCoin.conf.type);
    return XRPPublicKey.fromBytes(publicKey, algorithm: algorithm);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          keyIndex.toCbor(),
          publicKey,
          address.toCbor(),
          tag,
          network,
          accountName ?? const CborNullValue(),
          identifier
        ]),
        CborTagsConst.rippleAccount);
  }

  @override
  List get variabels {
    return [tag, keyIndex, network];
  }

  EllipticCurveTypes get curveType => coin.conf.type;

  @override
  String get type => addressType.value;

  @override
  String get baseAddress => networkAddress.address;
  @override
  final List<int> publicKey;

  @override
  RippleNewAddressParams toAccountParams() {
    return RippleNewAddressParams(deriveIndex: keyIndex, coin: coin, tag: tag);
  }

  Future<void> _setLastUpdateLedgerIndex(int ledgerIndex) async {
    if (_lastUpdateLedgerIndex == ledgerIndex) return;
    _lastUpdateLedgerIndex = ledgerIndex;
    await _saveAddress();
  }
}

final class IXRPMultisigAddress extends IXRPAddress
    implements MultiSigCryptoAccountAddress {
  IXRPMultisigAddress._(
      {required super.address,
      required super.network,
      required super.coin,
      required super.networkAddress,
      required super.tag,
      required this.multiSignatureAccount,
      required super.identifier,
      super.accountName})
      : super._(keyIndex: MultiSigAddressIndex(), publicKey: const []);
  @override
  RippleMultiSigNewAddressParams toAccountParams() {
    return RippleMultiSigNewAddressParams(
        coin: coin,
        masterAddress: networkAddress,
        multiSigAccount: multiSignatureAccount);
  }

  factory IXRPMultisigAddress._newAccount({
    required WalletXRPNetwork network,
    required CryptoCoins coin,
    required int? tag,
    required XRPAddress address,
    required RippleMultiSignatureAddress multiSigAccount,
    required String identifier,
  }) {
    final balance =
        ChainAccountBalance(address: address.toAddress(), network: network);
    return IXRPMultisigAddress._(
        coin: coin,
        multiSignatureAccount: multiSigAccount,
        address: balance,
        networkAddress: address,
        network: network.value,
        tag: tag,
        identifier: identifier);
  }
  factory IXRPMultisigAddress.deserialize(WalletNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CborTagsConst.rippleMultisigAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(1));
    final int? tag = values.elementAs(2);
    final int networkId = values.elementAs(3);
    final XRPAddress rippleAddress = XRPAddress(address.toAddress);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final RippleMultiSignatureAddress multiSigAccount =
        RippleMultiSignatureAddress.deserialize(
            obj: values.elementAsCborTag(4));
    final String? accountName = values.elementAs(5);
    final String identifier = values.elementAs(6);
    return IXRPMultisigAddress._(
        coin: coin,
        address: address,
        networkAddress: rippleAddress,
        network: networkId,
        tag: tag,
        multiSignatureAccount: multiSigAccount,
        accountName: accountName,
        identifier: identifier);
  }

  final RippleMultiSignatureAddress multiSignatureAccount;

  @override
  List<int> get publicKey =>
      throw WalletExceptionConst.featureUnavailableForMultiSignature;
  @override
  EllipticCurveTypes get curveType =>
      throw WalletExceptionConst.featureUnavailableForMultiSignature;

  @override
  List get variabels {
    return [tag, keyIndex, network, multiSignatureAccount];
  }

  @override
  List<Bip32AddressIndex> signerKeyIndexes() {
    return multiSignatureAccount.signers.map((e) => e.keyIndex).toList();
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          address.toCbor(),
          tag,
          network,
          multiSignatureAccount.toCbor(),
          accountName ?? const CborNullValue(),
          identifier
        ]),
        CborTagsConst.rippleMultisigAccount);
  }

  @override
  IAdressType get iAddressType => IAdressType.multisigByAddress;
}
