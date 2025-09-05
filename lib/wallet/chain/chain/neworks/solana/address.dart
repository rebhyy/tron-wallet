part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

final class ISolanaAddress extends ChainAccount<SolAddress, SolanaSPLToken,
    NFTCore, SolanaWalletTransaction> {
  ISolanaAddress._(
      {required super.keyIndex,
      required super.coin,
      required super.address,
      required super.network,
      required super.networkAddress,
      required super.identifier,
      super.accountName});

  factory ISolanaAddress._newAccount(
      {required List<int> publicKey,
      required WalletSolanaNetwork network,
      required AddressDerivationIndex keyIndex,
      required SolAddress address,
      required String identifier,
      required CryptoCoins coin}) {
    final balance =
        ChainAccountBalance(address: address.address, network: network);
    return ISolanaAddress._(
        coin: coin,
        address: balance,
        keyIndex: keyIndex,
        networkAddress: address,
        network: network.value,
        identifier: identifier);
  }

  factory ISolanaAddress.deserialize(WalletNetwork network,
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.solAccount);
    final CryptoCoins coin =
        CustomCoins.getSerializationCoin(values.elementAs(0));
    final keyIndex =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(1));
    final ChainAccountBalance address = ChainAccountBalance.deserialize(network,
        obj: values.elementAsCborTag(2));
    final SolAddress solAddress = SolAddress(address.toAddress);
    final int networkId = values.elementAs(3);
    if (networkId != network.value) {
      throw WalletExceptionConst.incorrectNetwork;
    }
    final String? accountName = values.elementAs(4);
    final String identifier = values.elementAs(5);
    return ISolanaAddress._(
        coin: coin,
        address: address,
        keyIndex: keyIndex,
        networkAddress: solAddress,
        network: networkId,
        accountName: accountName,
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
          accountName ?? const CborNullValue(),
          identifier
        ]),
        CborTagsConst.solAccount);
  }

  @override
  List get variabels {
    return [keyIndex, network];
  }

  @override
  List<int> get publicKey => networkAddress.toBytes();

  @override
  String? get type => null;

  SolAddress associatedTokenAccount(
          {required SolAddress mint,
          SolAddress tokenProgramId = SPLTokenProgramConst.tokenProgramId}) =>
      AssociatedTokenAccountProgramUtils.associatedTokenAccount(
              mint: mint, owner: networkAddress, tokenProgramId: tokenProgramId)
          .address;

  @override
  SolanaNewAddressParams toAccountParams() {
    return SolanaNewAddressParams(deriveIndex: keyIndex, coin: coin);
  }
}
