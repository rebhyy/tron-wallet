part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class ICardanoAddress
    extends ChainAccount<ADAAddress, TokenCore, NFTCore, ADAWalletTransaction>
    with CardanoChainAccountRepository, CardanoChainAccountController {
  final ADAAddressUtxos _utxos = ADAAddressUtxos();

  final OnceRunner<ADAAddressUtxos> _utxosRunner = OnceRunner();

  Future<ADAAddressUtxos> _getUtxos() async {
    return _utxosRunner.get(
        onFetch: () async {
          final utxos = await _getUtxosFromStorage();
          _utxos.updateUtxos(utxos.utxos);
          return _utxos;
        },
        onFetched: () => _utxos);
  }

  Future<void> _updateUtxos(Iterable<ADAAddressUtxo> utxos) async {
    if (_utxos.updateUtxos(utxos)) {
      await _saveAddressUtxo(_utxos);
    }
    await _updateAddressBalance(_utxos.totalLovelace);
  }

  ICardanoAddress._(
      {required super.keyIndex,
      required super.coin,
      required super.address,
      required super.network,
      required super.networkAddress,
      required this.addressInfo,
      required super.identifier,
      this.rewardKeyIndex,
      super.accountName})
      : rewardAddress = CardanoUtils.extractRewardAddress(networkAddress);

  factory ICardanoAddress._newAccount(
      {required ADAAddress address,
      required CryptoCoins coin,
      required AddressDerivationIndex keyIndex,
      required List<int> publicKey,
      required WalletCardanoNetwork network,
      required AddressDerivationIndex? rewardIndex,
      required String identifier,
      required CardanoAddrDetails addressInfo}) {
    final balance =
        ChainAccountBalance(address: address.address, network: network);
    return ICardanoAddress._(
        coin: coin,
        address: balance,
        keyIndex: keyIndex,
        networkAddress: address,
        network: network.value,
        addressInfo: addressInfo,
        rewardKeyIndex: rewardIndex,
        identifier: identifier);
  }

  factory ICardanoAddress.deserialize(WalletNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborTagValue cborTag =
        CborSerializable.decode(cborBytes: bytes, object: obj);
    if (BytesUtils.bytesEqual(
        cborTag.tags, CborTagsConst.cardanoMultisigAccount)) {
      return ICardanoMultiSigAddress.deserialize(network, obj: cborTag);
    }
    final CborListValue values = CborSerializable.cborTagValue(
        object: obj, cborBytes: bytes, tags: CborTagsConst.cardanoAccount);

    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final keyIndex =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(1));
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(2));
    final ADAAddress adaAddress = ADAAddress.fromAddress(address.toAddress);
    final int networkId = values.elementAs(3);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }

    final CardanoAddrDetails addrDetails =
        CardanoAddrDetails.deserialize(obj: values.elementAsCborTag(4));
    final String? accountName = values.elementAs(5);
    final CborTagValue? rewardIndexCbor = values.elementAsCborTag(6);
    final rewardIndex = rewardIndexCbor == null
        ? null
        : Bip32AddressIndex.deserialize(obj: rewardIndexCbor);
    if (adaAddress.addressType == ADAAddressType.base && rewardIndex == null) {
      throw WalletExceptionConst.invalidAccountDeta(
          "ICardanoAddress.deserialize");
    }
    final String identifier = values.elementAs(7);
    return ICardanoAddress._(
        coin: coin,
        address: address,
        keyIndex: keyIndex,
        networkAddress: adaAddress,
        network: networkId,
        addressInfo: addrDetails,
        accountName: accountName,
        rewardKeyIndex: rewardIndex,
        identifier: identifier);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          keyIndex.toCbor(),
          address.toCbor(),
          network,
          addressInfo.toCbor(),
          accountName ?? const CborNullValue(),
          rewardKeyIndex?.toCbor() ?? const CborNullValue(),
          identifier
        ]),
        CborTagsConst.cardanoAccount);
  }

  @override
  List get variabels {
    return [keyIndex, network, networkAddress.addressType, addressInfo];
  }

  final BaseCardanoAddressDetails addressInfo;

  final ADARewardAddress? rewardAddress;

  final AddressDerivationIndex? rewardKeyIndex;

  bool get isBaseAddress => addressInfo.addressType == ADAAddressType.base;
  bool get isRewardAddress => addressInfo.addressType == ADAAddressType.reward;
  @override
  String? get type => addressInfo.addressType.name;

  List<AddressDerivationIndex> get keyIndexes =>
      [keyIndex, if (rewardKeyIndex != null) rewardKeyIndex!];

  @override
  List<AddressDerivationIndex> signerKeyIndexes() {
    if (multiSigAccount) {
      throw WalletExceptionConst.featureUnavailableForMultiSignature;
    }
    return [keyIndex, if (rewardKeyIndex != null) rewardKeyIndex!];
  }

  @override
  BaseCardanoNewAddressParams toAccountParams() {
    final addressInfo = this.addressInfo as CardanoAddrDetails;
    return CardanoNewAddressParams(
        addressType: addressInfo.addressType,
        deriveIndex: keyIndex,
        rewardKeyIndex: rewardKeyIndex?.cast(),
        addressDetails: addressInfo,
        customHdPath: addressInfo.hdPath,
        customHdPathKey: addressInfo.hdPathKey,
        coin: coin);
  }

  @override
  List<int>? get publicKey => addressInfo.publicKey;

  List<int>? get rewardPublicKey {
    if (isRewardAddress) return publicKey;
    if (isBaseAddress) return addressInfo.stakePubkey;
    return null;
  }

  @override
  Future<void> _init() async {
    await super._init();
    await _getUtxos();
    _updateAddressBalance(_utxos.totalLovelace);
  }
}

final class ICardanoMultiSigAddress extends ICardanoAddress
    implements MultiSigCryptoAccountAddress {
  @override
  CardanoMultisigNewAddressParams toAccountParams() {
    return CardanoMultisigNewAddressParams(
        addressInfo: addressInfo, coin: coin);
  }

  factory ICardanoMultiSigAddress._newAccount(
      {required ADAAddress address,
      required CryptoCoins coin,
      required WalletCardanoNetwork network,
      required String identifier,
      required CardanoMultiSignatureAddressDetails addressInfo}) {
    final addressDetauls =
        ChainAccountBalance(address: address.address, network: network);
    return ICardanoMultiSigAddress._(
      coin: coin,
      address: addressDetauls,
      networkAddress: address,
      network: network.value,
      identifier: identifier,
      addressInfo: addressInfo,
    );
  }

  factory ICardanoMultiSigAddress.deserialize(WalletNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: obj,
        cborBytes: bytes,
        tags: CborTagsConst.cardanoMultisigAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(1));
    final ADAAddress adaAddress = ADAAddress.fromAddress(address.toAddress);
    final int networkId = values.elementAs(2);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }

    final CardanoMultiSignatureAddressDetails addrDetails =
        CardanoMultiSignatureAddressDetails.deserialize(
            obj: values.elementAsCborTag(3));
    final String? accountName = values.elementAs(4);
    final String identifier = values.elementAs(5);
    return ICardanoMultiSigAddress._(
        coin: coin,
        address: address,
        networkAddress: adaAddress,
        network: networkId,
        addressInfo: addrDetails,
        accountName: accountName,
        identifier: identifier);
  }
  ICardanoMultiSigAddress._({
    required super.coin,
    required super.address,
    required super.network,
    required super.addressInfo,
    required super.identifier,
    super.accountName,
    required super.networkAddress,
  }) : super._(
            keyIndex: MultiSigAddressIndex(),
            rewardKeyIndex: networkAddress.addressType == ADAAddressType.base
                ? MultiSigAddressIndex()
                : null);
  @override
  CardanoMultiSignatureAddressDetails get addressInfo =>
      super.addressInfo as CardanoMultiSignatureAddressDetails;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          address.toCbor(),
          network,
          addressInfo.toCbor(),
          accountName ?? const CborNullValue(),
          identifier
        ]),
        CborTagsConst.cardanoMultisigAccount);
  }

  @override
  List<Bip32AddressIndex> signerKeyIndexes() {
    return addressInfo.keyIndexes;
  }

  @override
  IAdressType get iAddressType => IAdressType.multisigByPublicKey;
}

base mixin CardanoChainAccountController
    on
        ChainAccount<ADAAddress, TokenCore, NFTCore, ADAWalletTransaction>,
        CardanoChainAccountRepository {}
base mixin CardanoChainAccountRepository
    on ChainAccount<ADAAddress, TokenCore, NFTCore, ADAWalletTransaction> {
  Future<ADAAddressUtxos> _getUtxosFromStorage() async {
    final storagekey = ADANetworkStorageId.utxos;
    final data =
        await _storage.queryNetworkStorage(address: this, storage: storagekey);
    if (data == null) return ADAAddressUtxos();
    final utxos = MethodUtils.nullOnException(
        () => ADAAddressUtxos.deserialize(bytes: data));
    assert(utxos != null, 'ADA Utxos deserialization failed.');
    return utxos ?? ADAAddressUtxos();
  }

  Future<void> _saveAddressUtxo(ADAAddressUtxos utxos) async {
    final storagekey = ADANetworkStorageId.utxos;
    await _storage.insertNetworkStorage(
        address: this, storage: storagekey, value: utxos);
  }
}
