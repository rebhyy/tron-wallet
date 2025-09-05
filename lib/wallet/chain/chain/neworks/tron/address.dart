part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class ITronAddress
    extends ChainAccount<TronAddress, TronToken, NFTCore, TronWalletTransaction>
    with TronChainAccountRepository, TronChainAccountController {
  ITronAddress._(
      {required super.keyIndex,
      required super.coin,
      required List<int> publicKey,
      required super.address,
      required super.network,
      required super.networkAddress,
      required super.identifier,
      super.accountName})
      : publicKey = List.unmodifiable(publicKey);

  factory ITronAddress._newAccount({
    required List<int> publicKey,
    required WalletTronNetwork network,
    required TronAddress address,
    required String identifier,
    required AddressDerivationIndex keyIndex,
    required CryptoCoins coin,
  }) {
    final balance =
        ChainAccountBalance(address: address.toAddress(), network: network);
    return ITronAddress._(
        coin: coin,
        publicKey: publicKey,
        address: balance,
        keyIndex: keyIndex,
        networkAddress: address,
        network: network.value,
        identifier: identifier);
  }

  factory ITronAddress.deserialize(WalletTronNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborTagValue toCborTag =
        CborSerializable.decode(cborBytes: bytes, object: obj);
    if (BytesUtils.bytesEqual(
        toCborTag.tags, CborTagsConst.tronMultisigAccount)) {
      return ITronMultisigAddress.deserialize(network, obj: toCborTag);
    }
    final CborListValue values = CborSerializable.cborTagValue(
        object: toCborTag, tags: CborTagsConst.tronAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final keyIndex =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(1));
    final List<int> publicKey = values.elementAs(2);
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(3));

    final TronAddress tronAddress = TronAddress(address.toAddress);
    final int networkId = values.elementAs(4);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String? accountName = values.elementAs(5);
    final String identifier = values.elementAs(6);

    return ITronAddress._(
        coin: coin,
        publicKey: publicKey,
        address: address,
        keyIndex: keyIndex,
        networkAddress: tronAddress,
        network: networkId,
        accountName: accountName,
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
          publicKey,
          address.toCbor(),
          network,
          accountName ?? const CborNullValue(),
          identifier,
        ]),
        CborTagsConst.tronAccount);
  }

  @override
  List get variabels {
    return [keyIndex, network];
  }

  @override
  String? get type => null;

  TronAccountResourceInfo? _accountResource;
  TronAccountResourceInfo? get accountResource => _accountResource;
  TronAccountInfo? _account;
  TronAccountInfo? get accountInfo => _account;

  Future<void> _updateAccountResource(
      TronAccountResourceInfo? accResource) async {
    if (accResource != _accountResource) {
      _accountResource = accResource;
      await _saveTronAccountResource(_accountResource);
    }
  }

  Future<void> _updateTronAccount(TronAccountInfo? tronAcc) async {
    if (tronAcc != _account) {
      _setTronAccount(tronAcc);
      await _saveTronAccountInfo(tronAcc);
    }
  }

  void _setTronAccount(TronAccountInfo? tronAcc) {
    _account = tronAcc;
    _updateAddressBalance(_account?.balance ?? BigInt.zero);
    if (tronAcc != null) {
      final trc10Tokens = tokens.where((e) => e.tronTokenType.isTrc10);
      for (final i in trc10Tokens) {
        final balance =
            tronAcc.assetV2.firstWhereNullable((e) => i.issuer == e.key);
        _updateTokenBalance(
            i, () => i._updateBalance(balance?.value ?? BigInt.zero));
      }
    }
  }

  @override
  TronNewAddressParams toAccountParams() {
    return TronNewAddressParams(deriveIndex: keyIndex, coin: coin);
  }

  @override
  Future<void> _init() async {
    await super._init();
    final resource = await _getTronAccountResource();
    _accountResource = resource;
    // _setAccountResource(resource);
    final accountInfo = await _getTronAccountInfo();
    _setTronAccount(accountInfo);
  }
}

final class ITronMultisigAddress extends ITronAddress
    implements MultiSigCryptoAccountAddress {
  ITronMultisigAddress._(
      {required super.address,
      required super.network,
      required super.coin,
      required super.networkAddress,
      required super.identifier,
      required this.multiSignatureAccount,
      super.accountName})
      : super._(keyIndex: MultiSigAddressIndex(), publicKey: const []);

  factory ITronMultisigAddress._newAccount({
    // required TronMultisigNewAddressParams accountParams,
    required CryptoCoins coin,
    required TronAddress address,
    required TronMultiSignatureAddress multiSigAccount,
    required WalletTronNetwork network,
    required String identifier,
  }) {
    final balance =
        ChainAccountBalance(address: address.toAddress(), network: network);

    return ITronMultisigAddress._(
        coin: coin,
        multiSignatureAccount: multiSigAccount,
        address: balance,
        networkAddress: address,
        network: network.value,
        accountName: null,
        identifier: identifier);
  }

  factory ITronMultisigAddress.deserialize(WalletNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.tronMultisigAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final TronMultiSignatureAddress multiSignatureAddress =
        TronMultiSignatureAddress.deserialize(obj: values.elementAsCborTag(1));
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(2));
    final TronAddress ethAddress = TronAddress(address.toAddress);
    final int networkId = values.elementAs(3);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }

    final String? accountName = values.elementAs(4);
    final String identifier = values.elementAs(5);
    return ITronMultisigAddress._(
        coin: coin,
        multiSignatureAccount: multiSignatureAddress,
        address: address,
        networkAddress: ethAddress,
        network: networkId,
        accountName: accountName,
        identifier: identifier);
  }
  final TronMultiSignatureAddress multiSignatureAccount;
  @override
  List<int> get publicKey =>
      throw WalletExceptionConst.featureUnavailableForMultiSignature;

  @override
  List get variabels {
    return [keyIndex, network, multiSignatureAccount];
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          coin.toCbor(),
          multiSignatureAccount.toCbor(),
          address.toCbor(),
          network,
          accountName ?? const CborNullValue(),
          identifier
        ]),
        CborTagsConst.tronMultisigAccount);
  }

  @override
  bool get multiSigAccount => true;

  @override
  List<Bip32AddressIndex> signerKeyIndexes() {
    return multiSignatureAccount.signers.map((e) => e.keyIndex).toList();
  }

  @override
  TronMultisigNewAddressParams toAccountParams() {
    return TronMultisigNewAddressParams(
        coin: coin,
        masterAddress: networkAddress,
        multiSigAccount: multiSignatureAccount);
  }

  @override
  IAdressType get iAddressType => IAdressType.multisigByAddress;
}

base mixin TronChainAccountController
    on
        ChainAccount<TronAddress, TronToken, NFTCore, TronWalletTransaction>,
        TronChainAccountRepository {}
base mixin TronChainAccountRepository
    on ChainAccount<TronAddress, TronToken, NFTCore, TronWalletTransaction> {
  Future<TronAccountInfo?> _getTronAccountInfo() async {
    final storagekey = TronNetworkStorageId.accountInfo;
    final data =
        await _storage.queryNetworkStorage(address: this, storage: storagekey);
    if (data == null) return null;
    final accountInfo = MethodUtils.nullOnException(
        () => TronAccountInfo.deserialize(bytes: data));
    assert(accountInfo != null, 'tron account info deserialization failed.');
    return accountInfo;
  }

  Future<void> _saveTronAccountInfo(TronAccountInfo? accountInfo) async {
    final storageKey = TronNetworkStorageId.accountInfo;
    if (accountInfo == null) {
      await _storage.removeNetworkStorage(address: this, storage: storageKey);
      return;
    }
    await _storage.insertNetworkStorage(
        address: this, storage: storageKey, value: accountInfo);
  }

  Future<TronAccountResourceInfo?> _getTronAccountResource() async {
    final storagekey = TronNetworkStorageId.accountResource;
    final data =
        await _storage.queryNetworkStorage(address: this, storage: storagekey);
    if (data == null) return null;
    final accountInfo = MethodUtils.nullOnException(
        () => TronAccountResourceInfo.deserialize(bytes: data));
    assert(
        accountInfo != null, 'tron account resource deserialization failed.');
    return accountInfo;
  }

  Future<void> _saveTronAccountResource(
      TronAccountResourceInfo? accountResource) async {
    final storagekey = TronNetworkStorageId.accountResource;
    if (accountResource == null) {
      await _storage.removeNetworkStorage(address: this, storage: storagekey);
      return;
    }
    await _storage.insertNetworkStorage(
        address: this, storage: storagekey, value: accountResource);
  }
}
