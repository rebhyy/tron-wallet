import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/models/sign_message.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/permission/models/account.dart';

class Web3BitcoinCashSignMessage
    extends Web3BitcoinCashRequestParam<Web3BitcoinSignMessageResponse>
    implements
        BaseWeb3BitcoinSignMessage<IBitcoinCashAddress,
            Web3BitcoinCashChainAccount> {
  @override
  final String message;
  @override
  final String? messagePrefix;
  @override
  final String? content;
  Web3BitcoinCashSignMessage._(
      {required this.accessAccount,
      required this.message,
      required this.content,
      required this.messagePrefix,
      required this.method});
  factory Web3BitcoinCashSignMessage(
      {required Web3BitcoinCashChainAccount account,
      required String message,
      required String? content,
      required String? messagePrefix,
      required Web3NetworkRequestMethods method}) {
    switch (method) {
      case Web3BitcoinCashRequestMethods.signMessage:
      case Web3BitcoinCashRequestMethods.signPersonalMessage:
        break;
      default:
        throw Web3RequestExceptionConst.internalError;
    }
    return Web3BitcoinCashSignMessage._(
        accessAccount: account,
        message: message,
        content: content,
        messagePrefix: messagePrefix,
        method: method.cast());
  }

  factory Web3BitcoinCashSignMessage.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    final method = Web3NetworkRequestMethods.fromTag(values.elementAs(0));
    return Web3BitcoinCashSignMessage(
        method: method,
        account: Web3BitcoinCashChainAccount.deserialize(
            object: values.elementAsCborTag(1)),
        message: values.elementAs(2),
        content: values.elementAs(3),
        messagePrefix: values.elementAs(4));
  }

  @override
  final Web3BitcoinCashRequestMethods method;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          method.tag,
          accessAccount.toCbor(),
          message,
          content,
          messagePrefix
        ]),
        type.tag);
  }

  final Web3BitcoinCashChainAccount accessAccount;

  @override
  Future<
      Web3BitcoinCashRequest<Web3BitcoinSignMessageResponse,
          Web3BitcoinCashSignMessage>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<IBitcoinCashAddress, BitcoinChain,
              Web3BitcoinCashChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3BitcoinCashRequest<Web3BitcoinSignMessageResponse,
        Web3BitcoinCashSignMessage>(
      params: this,
      authenticated: authenticated,
      chain: chain.$1,
      info: request,
      accounts: chain.$2,
    );
  }

  @override
  Object? toJsWalletResponse(Web3BitcoinSignMessageResponse response) {
    return response.toCbor().encode();
  }

  @override
  List<Web3BitcoinCashChainAccount> get requiredAccounts => [accessAccount];
}
