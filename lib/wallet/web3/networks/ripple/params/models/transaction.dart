import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/permission/models/account.dart';

final class Web3XRPTransactionSignatureResponse with CborSerializable {
  final String? txnSignature;
  final String? signingPubKey;
  final List<Web3XRPTransactionSignatureMultiSignerResponse>? signers;
  Map<String, dynamic> toJson() {
    return {
      'SigningPubKey': signingPubKey ?? '',
      'TxnSignature': txnSignature,
      "Signers": signers?.map((e) => e.toJson()).toList()
    };
  }

  Web3XRPTransactionSignatureResponse._({
    this.txnSignature,
    this.signingPubKey,
    List<Web3XRPTransactionSignatureMultiSignerResponse>? signers,
  }) : signers = signers?.emptyAsNull?.immutable;
  factory Web3XRPTransactionSignatureResponse(
      {required String txnSignature, required String signingPubKey}) {
    return Web3XRPTransactionSignatureResponse._(
        txnSignature: txnSignature, signingPubKey: signingPubKey);
  }
  factory Web3XRPTransactionSignatureResponse.multiSigner(
      List<Web3XRPTransactionSignatureMultiSignerResponse> signers) {
    return Web3XRPTransactionSignatureResponse._(signers: signers);
  }
  factory Web3XRPTransactionSignatureResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3XRPTransactionSignatureResponse._(
        txnSignature: values.elementAs(0),
        signingPubKey: values.elementAs(1),
        signers: values
            .elementAsListOf<CborTagValue>(2)
            .map((e) =>
                Web3XRPTransactionSignatureMultiSignerResponse.deserialize(
                    object: e))
            .toList());
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          txnSignature,
          signingPubKey,
          CborSerializable.fromDynamic(
              signers?.map((e) => e.toCbor()).toList() ?? [])
        ]),
        CborTagsConst.defaultTag);
  }

  Map<String, dynamic> toWalletConnectJson() {
    return toJson();
  }
}

final class Web3XRPTransactionSignatureMultiSignerResponse
    with CborSerializable {
  final String account;
  final String txnSignature;
  final String signingPubKey;
  const Web3XRPTransactionSignatureMultiSignerResponse(
      {required this.account,
      required this.txnSignature,
      required this.signingPubKey});
  factory Web3XRPTransactionSignatureMultiSignerResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3XRPTransactionSignatureMultiSignerResponse(
        account: values.elementAs(0),
        txnSignature: values.elementAs(1),
        signingPubKey: values.elementAs(2));
  }
  Map<String, dynamic> toJson() {
    return {
      'Signer': {
        'Account': account,
        'TxnSignature': txnSignature,
        'SigningPubKey': signingPubKey
      }
    };
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([account, txnSignature, signingPubKey]),
        CborTagsConst.defaultTag);
  }
}

final class Web3XRPTransactionResponse with CborSerializable {
  final Web3XRPTransactionSignatureResponse signature;
  final String txBlob;
  final String? txId;
  const Web3XRPTransactionResponse(
      {required this.signature, required this.txBlob, this.txId});
  factory Web3XRPTransactionResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3XRPTransactionResponse(
        signature: Web3XRPTransactionSignatureResponse.deserialize(
            object: values.elementAs<CborTagValue>(0)),
        txBlob: values.elementAs(1),
        txId: values.elementAs(2));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([signature.toCbor(), txBlob, txId]),
        CborTagsConst.defaultTag);
  }

  Map<String, dynamic> toJson() {
    return {
      "txId": txId,
      "tx_blob": txBlob,
      ...signature.toJson(),
    }.withOutNullValue;
  }

  Map<String, dynamic> toWalletConnectJson() {
    return toJson();
  }
}

class Web3XRPSendTransaction
    extends Web3XRPRequestParam<Web3XRPTransactionResponse> {
  final List<int> txBlob;
  final Web3XRPChainAccount account;
  Web3XRPSendTransaction._({
    required List<int> txBlob,
    required this.method,
    required this.account,
  }) : txBlob = txBlob.asImmutableBytes;
  factory Web3XRPSendTransaction(
      {required List<int> txBlob,
      required Web3NetworkRequestMethods method,
      required Web3XRPChainAccount account}) {
    switch (method) {
      case Web3XRPRequestMethods.sendTransaction:
      case Web3XRPRequestMethods.signTransaction:
        break;
      default:
        throw Web3RequestExceptionConst.internalError;
    }
    return Web3XRPSendTransaction._(
        txBlob: txBlob, method: method.cast(), account: account);
  }

  factory Web3XRPSendTransaction.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    final method = Web3NetworkRequestMethods.fromTag(values.elementAs(0));
    return Web3XRPSendTransaction(
        method: method,
        txBlob: values.elementAs(1),
        account: Web3XRPChainAccount.deserialize(
            object: values.elementAs<CborTagValue>(2)));
  }

  @override
  final Web3XRPRequestMethods method;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [method.tag, CborBytesValue(txBlob), account.toCbor()]),
        type.tag);
  }

  @override
  Future<Web3XRPRequest<Web3XRPTransactionResponse, Web3XRPSendTransaction>>
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
    return Web3XRPRequest<Web3XRPTransactionResponse, Web3XRPSendTransaction>(
        params: this,
        authenticated: authenticated,
        chain: chain.$1,
        info: request,
        accounts: chain.$2);
  }

  @override
  List<Web3XRPChainAccount> get requiredAccounts => [account];

  @override
  Object? toJsWalletResponse(Web3XRPTransactionResponse response) {
    return response.toCbor().encode();
  }
}
