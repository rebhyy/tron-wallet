part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class TonJettonToken extends TokenCore<IntegerBalance, Token> {
  TonJettonToken._(
      {required super.balance,
      required super.token,
      required this.minterAddress,
      required this.walletAddress,
      required super.updated})
      : super._();

  factory TonJettonToken.create({
    required BigInt balance,
    required Token token,
    required TonAddress minterAddress,
    required TonAddress walletAddress,
  }) {
    return TonJettonToken._(
      balance: IntegerBalance.token(balance, token, immutable: true),
      token: token,
      minterAddress: minterAddress,
      walletAddress: walletAddress,
      updated: DateTime.now(),
    );
  }
  factory TonJettonToken.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: TokenCoreType.jetton.tag);
    final Token token = Token.deserialize(obj: cbor.elementAsCborTag(0));
    final String minterAddress = cbor.elementAs(1);
    final String walletAddress = cbor.elementAs(2);
    final DateTime updated = cbor.elementAs(4);
    return TonJettonToken._(
        balance:
            IntegerBalance.token(cbor.elementAs(3), token, immutable: true),
        token: token,
        minterAddress: TonAddress(minterAddress),
        walletAddress: TonAddress(walletAddress),
        updated: updated);
  }

  final TonAddress minterAddress;
  final TonAddress walletAddress;

  bool _updateBalance([BigInt? updateBalance]) {
    if (streamBalance.value._internalUpdateBalance(updateBalance)) {
      _updated = DateTime.now().toLocal();
      streamBalance.notify();
      return true;
    }
    return false;
  }

  @override
  TonJettonToken clone() {
    return TonJettonToken.create(
      balance: streamBalance.value.balance,
      token: token,
      minterAddress: minterAddress,
      walletAddress: walletAddress,
    );
  }

  @override
  TonJettonToken updateToken(Token updateToken) {
    return TonJettonToken.create(
      balance: streamBalance.value.balance,
      token: updateToken,
      minterAddress: minterAddress,
      walletAddress: walletAddress,
    );
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          token.toCbor(),
          minterAddress.toFriendlyAddress(),
          walletAddress.toFriendlyAddress(),
          streamBalance.value.balance,
          CborEpochIntValue(_updated),
        ]),
        tokenType.tag);
  }

  @override
  List get variabels => [minterAddress, walletAddress];

  @override
  String? get issuer => minterAddress.toFriendlyAddress();

  @override
  late final String? type = "Jetton";
  @override
  TokenCoreType get tokenType => TokenCoreType.jetton;

  @override
  String get identifier => minterAddress.toFriendlyAddress();
}
