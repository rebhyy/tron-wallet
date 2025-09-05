import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/params/models/sign_message.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/params/models/transaction.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/permission/models/account.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';

abstract class Web3MoneroRequestParam<RESPONSE> extends Web3RequestParams<
    RESPONSE,
    MoneroAddress,
    MoneroChain,
    IMoneroAddress,
    Web3MoneroChainAccount> {
  @override
  abstract final Web3MoneroRequestMethods method;

  Web3MoneroRequestParam();

  factory Web3MoneroRequestParam.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    final method = Web3NetworkRequestMethods.fromTag(values.elementAs(0));
    final Web3MoneroRequestParam param;
    switch (method) {
      case Web3MoneroRequestMethods.sendTransaction:
        param = Web3MoneroSendTransaction.deserialize(
            bytes: bytes, object: object, hex: hex);
      case Web3MoneroRequestMethods.signMessage:
        param = Web3MoneroSignMessage.deserialize(
            bytes: bytes, object: object, hex: hex);
      default:
        throw Web3RequestExceptionConst.internalError;
    }
    if (param is! Web3MoneroRequestParam<RESPONSE>) {
      throw Web3RequestExceptionConst.internalError;
    }
    return param;
  }
}

class Web3MoneroRequest<RESPONSE,
        PARAMS extends Web3MoneroRequestParam<RESPONSE>>
    extends Web3NetworkRequest<RESPONSE, MoneroAddress, MoneroChain,
        Web3MoneroChainAccount, IMoneroAddress, PARAMS> {
  Web3MoneroRequest(
      {required super.params,
      required super.info,
      required super.authenticated,
      required super.chain,
      required super.accounts});

  Web3MoneroRequest<R, P> cast<R, P extends Web3MoneroRequestParam<R>>() {
    return this as Web3MoneroRequest<R, P>;
  }
}
