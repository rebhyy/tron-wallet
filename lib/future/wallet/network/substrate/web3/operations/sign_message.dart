import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/crypto/requets/messages.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/web3/types/types.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/wallet/web3/core/state.dart';
import 'package:on_chain_wallet/wallet/api/api.dart';
import 'package:on_chain_wallet/wallet/models/signing/signing.dart';
import 'package:on_chain_wallet/wallet/web3/networks/substrate/params/models/sign_message.dart';
import 'package:on_chain_wallet/wallet/web3/networks/substrate/params/models/transaction.dart';

class Web3SubstrateSignMessageStateController
    extends Web3SubstrateStateController<Web3SubstrateSendTransactionResponse,
        SubstrateClient?, Web3SubstrateSignMessage> {
  String? get content => params.content;
  String get message => params.challeng;
  late final List<int> payloadMessage =
      BytesUtils.fromHexString(params.challeng).toImutableBytes;

  Web3SubstrateSignMessageStateController(
      {required super.walletProvider, required super.request});

  @override
  Future<Web3RequestResponseData<Web3SubstrateSendTransactionResponse>>
      getResponse() async {
    final signature = await walletProvider.wallet.signTransaction(
        request: WalletSigningRequest(
      addresses: [defaultAccount],
      network: network,
      sign: (generateSignature) async {
        final signRequest = GlobalSignRequest.substrate(
            digest: payloadMessage, index: defaultAccount.keyIndex.cast());
        final response = await generateSignature(signRequest);
        return Web3SubstrateSendTransactionResponse(
            signature: response.signature);
      },
    ));
    return Web3RequestResponseData(response: signature.result);
  }

  @override
  Widget widgetBuilder(BuildContext context) {
    return Web3StateSignMessageView(
        controller: this,
        message: message,
        content: content,
        isPersonalSign: true);
  }
}
