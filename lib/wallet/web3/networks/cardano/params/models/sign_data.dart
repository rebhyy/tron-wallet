import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/permission/models/account.dart';

class Web3ADASignDataResponse with CborSerializable {
  final List<int> signature;
  final List<int> key;
  final List<int> pubKey;
  Web3ADASignDataResponse({
    required List<int> signature,
    required List<int> key,
    required List<int> pubKey,
  })  : signature = signature.asImmutableBytes,
        key = key.asImmutableBytes,
        pubKey = pubKey.asImmutableBytes;
  factory Web3ADASignDataResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3ADASignDataResponse(
        signature: values.valueAs(0),
        key: values.valueAs(1),
        pubKey: values.valueAs(2));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue.definite([
          CborBytesValue(signature),
          CborBytesValue(key),
          CborBytesValue(pubKey)
        ]),
        CborTagsConst.defaultTag);
  }

  Map<String, dynamic> toWalletConnectJson() {
    return {
      "signature": BytesUtils.toHexString(signature),
      "key": BytesUtils.toHexString(key),
      "pubKey": BytesUtils.toHexString(pubKey)
    };
  }
}

class Web3ADASignData extends Web3ADARequestParam<Web3ADASignDataResponse> {
  final Web3ADAChainAccount accessAccount;
  final String challeng;
  final String? content;

  Web3ADASignData(
      {required this.accessAccount, required this.challeng, this.content});

  factory Web3ADASignData.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
      cborBytes: bytes,
      object: object,
      hex: hex,
      tags: Web3MessageTypes.walletRequest.tag,
    );
    final List<int> challeng = values.elementAs(2);
    return Web3ADASignData(
        accessAccount: Web3ADAChainAccount.deserialize(
            object: values.elementAs<CborTagValue>(1)),
        challeng: BytesUtils.toHexString(challeng, prefix: "0x"),
        content: values.elementAs(3));
  }

  @override
  Web3ADARequestMethods get method => Web3ADARequestMethods.signData;

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
  Future<Web3ADARequest<Web3ADASignDataResponse, Web3ADASignData>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<ICardanoAddress, ADAChain,
              Web3ADAChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3ADARequest<Web3ADASignDataResponse, Web3ADASignData>(
        params: this,
        authenticated: authenticated,
        chain: chain.$1,
        info: request,
        accounts: chain.$2);
  }

  @override
  List<Web3ADAChainAccount> get requiredAccounts => [accessAccount];

  @override
  Object? toJsWalletResponse(Web3ADASignDataResponse response) {
    return response.toCbor().encode();
  }
}
