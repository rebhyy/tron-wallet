import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:on_chain_wallet/app/serialization/serialization.dart';
import 'package:on_chain_wallet/wallet/api/provider/core/provider.dart';
import 'package:on_chain_wallet/wallet/models/network/core/params/params.dart';
import 'package:on_chain_wallet/wallet/models/token/token/token.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/cardano.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:blockchain_utils/bip/bip.dart';

class CardanoNetworkParams extends NetworkCoinParams<CardanoAPIProvider> {
  final ADANetwork networkType;
  String get chainId {
    return "${networkType.value}-${networkType.protocolMagic}";
  }

  factory CardanoNetworkParams.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CborTagsConst.cardanoNetworkParams);

    return CardanoNetworkParams(
        token: Token.deserialize(obj: values.elementAsCborTag(2)),
        providers: values
            .elementAsListOf<CborTagValue>(3)
            .map((e) => CardanoAPIProvider.fromCborBytesOrObject(obj: e))
            .toList(),
        chainType: ChainType.fromValue(values.elementAs(4)),
        networkType: ADANetwork.fromProtocolMagic(values.elementAs(5)),
        addressExplorer: values.elementAs(6),
        transactionExplorer: values.elementAs(7));
  }
  CardanoNetworkParams(
      {required super.token,
      required super.providers,
      required super.chainType,
      required this.networkType,
      super.addressExplorer,
      super.transactionExplorer});

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          const CborNullValue(),
          const CborNullValue(),
          token.toCbor(),
          CborSerializable.fromDynamic(
              providers.map((e) => e.toCbor()).toList()),
          chainType.name,
          networkType.protocolMagic,
          addressExplorer,
          transactionExplorer
        ]),
        CborTagsConst.cardanoNetworkParams);
  }

  int get identifier => networkType.protocolMagic;

  @override
  NetworkCoinParams<CardanoAPIProvider> updateParams(
      {List<APIProvider>? updateProviders,
      Token? token,
      String? transactionExplorer,
      String? addressExplorer,
      int? bip32CoinType}) {
    return CardanoNetworkParams(
        token: NetworkCoinParams.validateUpdateParams(
            token: this.token, updateToken: token),
        providers: updateProviders?.cast<CardanoAPIProvider>() ?? providers,
        chainType: chainType,
        networkType: networkType,
        addressExplorer: addressExplorer,
        transactionExplorer: transactionExplorer);
  }
}
