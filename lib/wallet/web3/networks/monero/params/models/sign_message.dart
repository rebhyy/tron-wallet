import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/permission/models/account.dart';

class Web3MoneroSignMessageResponse with CborSerializable {
  final List<int> signature;
  Web3MoneroSignMessageResponse({required List<int> signature})
      : signature = signature.asImmutableBytes;
  factory Web3MoneroSignMessageResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3MoneroSignMessageResponse(signature: values.elementAs(0));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([CborBytesValue(signature)]),
        CborTagsConst.defaultTag);
  }

  Map<String, dynamic> toWalletConnectJson() {
    return {"signature": BytesUtils.toHexString(signature, lowerCase: false)};
  }
}

class Web3MoneroSignMessage
    extends Web3MoneroRequestParam<Web3MoneroSignMessageResponse> {
  final Web3MoneroChainAccount accessAccount;
  final String challeng;
  final String? content;

  Web3MoneroSignMessage(
      {required this.accessAccount, required this.challeng, this.content});

  factory Web3MoneroSignMessage.deserialize({
    List<int>? bytes,
    CborObject? object,
    String? hex,
  }) {
    final CborListValue values = CborSerializable.cborTagValue(
      cborBytes: bytes,
      object: object,
      hex: hex,
      tags: Web3MessageTypes.walletRequest.tag,
    );
    final List<int> challeng = values.elementAs(2);
    return Web3MoneroSignMessage(
        accessAccount: Web3MoneroChainAccount.deserialize(
            object: values.elementAs<CborTagValue>(1)),
        challeng: BytesUtils.toHexString(challeng, prefix: "0x"),
        content: values.elementAs(3));
  }

  @override
  Web3MoneroRequestMethods get method => Web3MoneroRequestMethods.signMessage;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          method.tag,
          accessAccount.toCbor(),
          CborBytesValue(BytesUtils.fromHexString(challeng)),
          content
        ]),
        type.tag);
  }

  List<int> chalengBytes() {
    return BytesUtils.fromHexString(challeng);
  }

  @override
  Future<
      Web3MoneroRequest<Web3MoneroSignMessageResponse,
          Web3MoneroSignMessage>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<IMoneroAddress, MoneroChain,
              Web3MoneroChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3MoneroRequest<Web3MoneroSignMessageResponse,
        Web3MoneroSignMessage>(
      params: this,
      authenticated: authenticated,
      chain: chain.$1,
      info: request,
      accounts: chain.$2,
    );
  }

  @override
  List<Web3MoneroChainAccount> get requiredAccounts => [accessAccount];

  @override
  Object? toJsWalletResponse(Web3MoneroSignMessageResponse response) {
    return response.toCbor().encode();
  }
}
