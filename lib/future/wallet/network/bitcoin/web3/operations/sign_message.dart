import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/signer/bitcoin/bitcoin_signer.dart';
import 'package:blockchain_utils/utils/binary/utils.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/utils/method/utiils.dart';
import 'package:on_chain_wallet/crypto/requets/messages/messages.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/types/types.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/wallet/web3/core/state.dart';
import 'package:on_chain_wallet/wallet/api/api.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/constant/constants/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/models/sign_message.dart';

class Web3BitcoinSignMessageStateController extends Web3BitcoinStateController<
    Web3BitcoinSignMessageResponse,
    BitcoinClient?,
    BaseWeb3BitcoinSignMessage> {
  late final List<int> payloadMessage =
      BytesUtils.fromHexString(params.message).asImmutableBytes;
  String get message => request.params.message;
  String? get content => request.params.content;
  late final String _messagePrefix =
      request.params.messagePrefix ?? BitcoinSignerUtils.signMessagePrefix;
  String get messagePrefix => _messagePrefix;
  BIP137Mode _mode = BIP137Mode.p2pkhCompressed;
  BIP137Mode get mode => _mode;
  bool get isPersonalMessage => true;

  Web3BitcoinSignMessageStateController(
      {required super.walletProvider, required super.request});

  @override
  Future<Web3RequestResponseData<Web3BitcoinSignMessageResponse>>
      getResponse() async {
    final account = defaultAccount;
    MethodResult<CryptoBitcoinPersonalSignResponse> sign = await walletProvider
        .wallet
        .walletRequest(WalletRequestBitcoinSignMessage(
            message: payloadMessage,
            index: account.keyIndex.cast(),
            useTaproot: account.addressType.isP2tr,
            mode: mode,
            messagePrefix: messagePrefix));
    return Web3RequestResponseData(
        response: Web3BitcoinSignMessageResponse(
            signature: sign.result.signature, digest: sign.result.digest));
  }

  @override
  Widget widgetBuilder(BuildContext context) {
    return Web3StateSignMessageView(
        controller: this,
        message: message,
        content: content,
        isPersonalSign: isPersonalMessage,
        prefix: messagePrefix);
  }

  @override
  Future<void> initForm(BitcoinClient<IBitcoinAddress>? client) async {
    final account = defaultAccount;
    switch (account.networkAddress.type) {
      case P2pkhAddressType.p2pkh:
      case P2pkhAddressType.p2pkhwt:
        if (!account.keyType.isCompressed) {
          _mode = BIP137Mode.p2pkhUncompressed;
        }
        break;
      case P2shAddressType.p2wpkhInP2sh:
        _mode = BIP137Mode.p2shP2wpkh;
        break;
      case SegwitAddressType.p2tr:
        break;
      case SegwitAddressType.p2wpkh:
        _mode = BIP137Mode.p2wpkh;
        break;
      default:
        throw Web3BitcoinExceptionConstant.unsuportedSigningMessageAccount(
            account.address.toAddress);
    }
  }
}
