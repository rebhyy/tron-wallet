import 'package:blockchain_utils/bip/bip/bip.dart';
import 'package:blockchain_utils/bip/ecc/curve/elliptic_curve_types.dart';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/utils/utils.dart';
import 'conf.dart';

class CustomCoins extends BipCoins {
  CustomCoins._(this.name, this.conf);
  final String name;
  @override
  String get coinName => name;

  @override
  final BipCoinConfig conf;

  @override
  BipProposal get proposal => CustomProposal.cip0019;

  @override
  CryptoCoins get value => this;

  static final CustomCoins byronLegacy =
      CustomCoins._("Byron legacy", CustomCurrencyConf.byronLegacy);
  static final CustomCoins byronLegacyTestnet = CustomCoins._(
      "Byron legacy testnet", CustomCurrencyConf.byronLegacyTestnet);
  static final List<CustomCoins> values = [byronLegacy, byronLegacyTestnet];
  static T getSerializationCoin<T extends CryptoCoins>(
      String serializationStr) {
    final parts = serializationStr.split("#");
    if (parts.length != 2) {
      throw AppSerializationException(objectName: "getSerializationCoin");
    }
    return getCoin(name: parts[1], proposal: parts[0]);
  }

  static T getCoin<T extends CryptoCoins>(
      {required String name, required String proposal}) {
    CryptoCoins? coin;
    switch (proposal) {
      case CustomProposal._cip0019OldName:
        coin = CustomCoins.fromName(name);
        break;
      default:
        coin = CryptoCoins.getCoin(name, CustomProposal.fromName(proposal));
        break;
    }
    if (coin == null || coin is! T) {
      throw AppCryptoExceptionConst.invalidCoin;
    }
    return coin;
  }

  static List<CryptoCoins> fromCurve<T extends CryptoCoins>(
      EllipticCurveTypes type,
      {CoinProposal? proposal}) {
    List<CryptoCoins> coins;
    switch (proposal) {
      case CustomProposal.cip0019:
        coins = _fromCurve(type);
        break;
      case null:
        return [
          ..._fromCurve(type),
          ...CryptoCoins.fromCurve(type, proposal: proposal)
        ];
      default:
        coins = CryptoCoins.fromCurve(type, proposal: proposal);
        break;
    }
    return coins;
  }

  static CustomCoins? fromName(String name) {
    return values.firstWhereOrNull((element) => element.name == name);
  }

  static List<CustomCoins> _fromCurve(EllipticCurveTypes type) {
    return values.where((element) => element.conf.type == type).toList();
  }
}

class CustomProposal implements BipProposal {
  static const CustomProposal cip0019 = CustomProposal._(_cip0019OldName);

  const CustomProposal._(this.name);
  @override
  final String name;

  @override
  String get specName => name;
  @override
  CustomProposal get value => this;
  static const String _cip0019OldName = "CIP-0019";
  static const List<CoinProposal> values = [cip0019];

  @override
  Bip32KeyIndex get purpose => Bip32KeyIndex(0);

  static CoinProposal fromName(String name) {
    if (name == _cip0019OldName) return CustomProposal.cip0019;
    return CoinProposal.fromName(name);
  }
}
