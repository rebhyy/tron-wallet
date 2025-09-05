import 'package:on_chain_wallet/app/error/exception/app_exception.dart';

enum TonChainId {
  mainnet(value: '-239', workchain: 0),
  testnet(value: '-3', workchain: -1);

  final String value;
  final int workchain;

  const TonChainId({required this.value, required this.workchain});
  static TonChainId fromNetworkId(int id) {
    return values.firstWhere((e) => e.workchain == id,
        orElse: () =>
            throw AppSerializationException(objectName: "TonChainId"));
  }
}
