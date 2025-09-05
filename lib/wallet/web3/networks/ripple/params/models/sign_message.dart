import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/permission/models/account.dart';

class Web3XRPSignMessageResponse with CborSerializable {
  final List<int> signature;
  final List<int> publicKey;
  Web3XRPSignMessageResponse(
      {required List<int> signature, required List<int> publicKey})
      : signature = signature.asImmutableBytes,
        publicKey = publicKey.asImmutableBytes;
  factory Web3XRPSignMessageResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3XRPSignMessageResponse(
        signature: values.elementAs(0), publicKey: values.elementAs(1));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [CborBytesValue(signature), CborBytesValue(publicKey)]),
        CborTagsConst.defaultTag);
  }

  Map<String, dynamic> toWalletConnectJson() {
    return {
      "signature": BytesUtils.toHexString(signature, lowerCase: false),
      "public_key": BytesUtils.toHexString(publicKey, lowerCase: false),
    };
  }
}

class Web3XRPSignMessage
    extends Web3XRPRequestParam<Web3XRPSignMessageResponse> {
  final Web3XRPChainAccount accessAccount;
  final String challeng;
  final String? content;

  Web3XRPSignMessage(
      {required this.accessAccount, required this.challeng, this.content});

  factory Web3XRPSignMessage.deserialize({
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
    return Web3XRPSignMessage(
        accessAccount: Web3XRPChainAccount.deserialize(
            object: values.elementAs<CborTagValue>(1)),
        challeng: BytesUtils.toHexString(challeng, prefix: "0x"),
        content: values.elementAs(3));
  }

  @override
  Web3XRPRequestMethods get method => Web3XRPRequestMethods.signMessage;

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
  Future<Web3XRPRequest<Web3XRPSignMessageResponse, Web3XRPSignMessage>>
      toRequest(
          {required Web3RequestInformation request,
          required Web3RequestAuthentication authenticated,
          required WEB3REQUESTNETWORKCONTROLLER<IXRPAddress, XRPChain,
                  Web3XRPChainAccount>
              chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3XRPRequest<Web3XRPSignMessageResponse, Web3XRPSignMessage>(
      params: this,
      authenticated: authenticated,
      chain: chain.$1,
      info: request,
      accounts: chain.$2,
    );
  }

  @override
  List<Web3XRPChainAccount> get requiredAccounts => [accessAccount];

  @override
  Object? toJsWalletResponse(Web3XRPSignMessageResponse response) {
    return response.toCbor().encode();
  }
}
