import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:on_chain_wallet/app/serialization/serialization.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart' show NetworkType;
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/global/methods/methods.dart';

class Web3SilentConnectApplication
    extends Web3GlobalRequestParams<List<NetworkType>> {
  final NetworkType? chain;
  factory Web3SilentConnectApplication.global() {
    return Web3SilentConnectApplication._();
  }
  factory Web3SilentConnectApplication.network(NetworkType network) {
    return Web3SilentConnectApplication._(chain: network);
  }
  Web3SilentConnectApplication._({this.chain});

  factory Web3SilentConnectApplication.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletGlobalRequest.tag);
    return Web3SilentConnectApplication._(
        chain: values.elemetMybeAs<NetworkType, CborStringValue>(
            1, (e) => NetworkType.fromName(e.value)));
  }

  @override
  Web3GlobalRequestMethods get method => Web3GlobalRequestMethods.connectSilent;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([method.id, chain?.name]), type.tag);
  }

  @override
  Object? toJsWalletResponse(response) {
    return null;
  }
}
