import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/params/models/send_transaction.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/params/models/sign_message.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/params/models/transaction.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/permission/models/account.dart';

abstract class Web3BitcoinCashRequestParam<RESPONSE>
    extends BaseWeb3BitcoinRequestParam<RESPONSE, IBitcoinCashAddress,
        Web3BitcoinCashChainAccount> {
  @override
  abstract final Web3BitcoinCashRequestMethods method;

  Web3BitcoinCashRequestParam();

  factory Web3BitcoinCashRequestParam.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    final method = Web3NetworkRequestMethods.fromTag(values.elementAs(0));
    final Web3BitcoinCashRequestParam param;
    switch (method) {
      case Web3BitcoinCashRequestMethods.signTransaction:
        param = Web3BitcoinCashSignTransaction.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case Web3BitcoinCashRequestMethods.signPersonalMessage:
        param = Web3BitcoinCashSignMessage.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case Web3BitcoinCashRequestMethods.sendTransaction:
        param = Web3BitcoinCashSendTransaction.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;

      default:
        throw Web3RequestExceptionConst.internalError;
    }
    if (param is! Web3BitcoinCashRequestParam<RESPONSE>) {
      throw Web3RequestExceptionConst.internalError;
    }
    return param;
  }
}

class Web3BitcoinCashRequest<RESPONSE,
        PARAMS extends Web3BitcoinCashRequestParam<RESPONSE>>
    extends BaseWeb3BitcoinRequest<RESPONSE, IBitcoinCashAddress,
        Web3BitcoinCashChainAccount, PARAMS> {
  Web3BitcoinCashRequest(
      {required super.params,
      required super.info,
      required super.authenticated,
      required super.chain,
      required super.accounts});

  // Web3BitcoinCashRequest<R, P>
  //     cast<R, P extends Web3BitcoinCashRequestParam<R>>() {
  //   return this as Web3BitcoinCashRequest<R, P>;
  // }
}
