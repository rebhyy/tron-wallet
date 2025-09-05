import 'package:on_chain/ada/src/ada.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/models/get_accout_pub_key.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/models/get_collateral.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/models/sign_data.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/models/sign_message.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/models/transaction.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/permission/models/account.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';

abstract class Web3ADARequestParam<RESPONSE> extends Web3RequestParams<RESPONSE,
    ADAAddress, ADAChain, ICardanoAddress, Web3ADAChainAccount> {
  @override
  abstract final Web3ADARequestMethods method;

  Web3ADARequestParam();

  factory Web3ADARequestParam.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    final method = Web3NetworkRequestMethods.fromTag(values.elementAs(0));
    final Web3ADARequestParam param;
    switch (method) {
      case Web3ADARequestMethods.signTransaction:
      case Web3ADARequestMethods.signTx:
      case Web3ADARequestMethods.signAndSendTransaction:
      case Web3ADARequestMethods.submitTx:
      case Web3ADARequestMethods.submitUnsignedTx:
      case Web3ADARequestMethods.submitTxs:
      case Web3ADARequestMethods.signTxs:
        param = Web3ADASignTransaction.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case Web3ADARequestMethods.signMessage:
        param = Web3ADASignMessage.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case Web3ADARequestMethods.getCollateral:
        param = Web3ADAGetCollateral.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case Web3ADARequestMethods.getAccountPub:
        param = Web3ADAGetAccountPub.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case Web3ADARequestMethods.signData:
        param =
            Web3ADASignData.deserialize(bytes: bytes, object: object, hex: hex);
        break;
      default:
        throw Web3RequestExceptionConst.internalError;
    }
    if (param is! Web3ADARequestParam<RESPONSE>) {
      throw Web3RequestExceptionConst.internalError;
    }
    return param;
  }
}

class Web3ADARequest<RESPONSE, PARAMS extends Web3ADARequestParam<RESPONSE>>
    extends Web3NetworkRequest<RESPONSE, ADAAddress, ADAChain,
        Web3ADAChainAccount, ICardanoAddress, PARAMS> {
  Web3ADARequest(
      {required super.params,
      required super.info,
      required super.authenticated,
      required super.chain,
      required super.accounts});

  Web3ADARequest<R, P> cast<R, P extends Web3ADARequestParam<R>>() {
    return this as Web3ADARequest<R, P>;
  }
}
