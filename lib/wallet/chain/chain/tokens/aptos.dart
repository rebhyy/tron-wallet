part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

class AptosFATokens extends TokenCore<IntegerBalance, Token> {
  AptosFATokens._(
      {required super.balance,
      required super.token,
      required super.updated,
      required this.assetType,
      required bool isFreeze})
      : _isFreeze = isFreeze,
        super._();
  factory AptosFATokens.create({
    required BigInt balance,
    required Token token,
    required String assetType,
    bool isFreeze = false,
  }) {
    return AptosFATokens._(
        balance: IntegerBalance.token(balance, token, immutable: true),
        token: token,
        updated: DateTime.now(),
        assetType: assetType,
        isFreeze: isFreeze);
  }
  factory AptosFATokens.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: TokenCoreType.aptos.tag);

    final Token token = Token.deserialize(obj: values.elementAsCborTag(0));
    final IntegerBalance balance =
        IntegerBalance.token(values.elementAs(1), token, immutable: true);
    final DateTime updated = values.elementAs(2);
    final String denom = values.elementAs(3);
    final bool isFreez = values.elementAs<bool>(4);
    return AptosFATokens._(
        balance: balance,
        token: token,
        updated: updated,
        assetType: denom,
        isFreeze: isFreez);
  }

  @override
  AptosFATokens clone({BigInt? balance}) {
    return AptosFATokens.create(
        balance: balance ?? streamBalance.value.balance,
        token: token,
        assetType: assetType);
  }

  @override
  AptosFATokens updateToken(Token updateToken) {
    return AptosFATokens.create(
        balance: streamBalance.value.balance,
        token: updateToken,
        assetType: assetType);
  }

  final String assetType;
  bool _isFreeze;
  bool get isFreeze => _isFreeze;
  bool setFreeze(bool freeze) {
    bool f = _isFreeze;
    _isFreeze = freeze;
    return freeze != f;
  }

  bool _updateBalance([BigInt? updateBalance]) {
    if (streamBalance.value._internalUpdateBalance(updateBalance)) {
      _updated = DateTime.now().toLocal();
      streamBalance.notify();
      return true;
    }
    return false;
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          token.toCbor(),
          streamBalance.value.balance,
          CborEpochIntValue(_updated),
          assetType,
          _isFreeze
        ]),
        tokenType.tag);
  }

  @override
  String? get issuer => assetType;

  @override
  late final String? type = "FATs";

  @override
  TokenCoreType get tokenType => TokenCoreType.aptos;

  @override
  String get identifier => assetType;
  @override
  List get variabels => [assetType];
}
