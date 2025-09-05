import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/constant/constants/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/permission/models/account.dart';

final class Web3MoneroTransactionProofsResponse with CborSerializable {
  final String address;
  final String proof;
  const Web3MoneroTransactionProofsResponse(
      {required this.address, required this.proof});
  factory Web3MoneroTransactionProofsResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3MoneroTransactionProofsResponse(
        address: values.elementAs(0), proof: values.elementAs(1));
  }
  Map<String, dynamic> toJson() {
    return {"address": address, "proof": proof};
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(CborSerializable.fromDynamic([address, proof]),
        CborTagsConst.defaultTag);
  }
}

final class Web3MoneroTransactionResponse with CborSerializable {
  final List<Web3MoneroTransactionProofsResponse> proofs;
  final String txId;
  Web3MoneroTransactionResponse(
      {required List<Web3MoneroTransactionProofsResponse> proofs,
      required this.txId})
      : proofs = proofs.immutable;
  factory Web3MoneroTransactionResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3MoneroTransactionResponse(
        txId: values.elementAs(0),
        proofs: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) =>
                Web3MoneroTransactionProofsResponse.deserialize(object: e))
            .toList());
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          txId,
          CborSerializable.fromDynamic(proofs.map((e) => e.toCbor()).toList()),
        ]),
        CborTagsConst.defaultTag);
  }

  Map<String, dynamic> toJson() {
    return {"txId": txId, "proofs": proofs.map((e) => e.toJson()).toList()};
  }

  Map<String, dynamic> toWalletConnectJson() {
    return toJson();
  }
}

final class Web3MoneroTransactionParams with CborSerializable {
  final MoneroAddress destination;
  final BigInt amount;
  const Web3MoneroTransactionParams(
      {required this.destination, required this.amount});
  factory Web3MoneroTransactionParams.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3MoneroTransactionParams(
      destination: MoneroAddress(values.elementAs(0)),
      amount: values.elementAs(1),
    );
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([destination.address, amount]),
        CborTagsConst.defaultTag);
  }
}

class Web3MoneroSendTransaction
    extends Web3MoneroRequestParam<Web3MoneroTransactionResponse> {
  final List<Web3MoneroTransactionParams> destintions;
  final Web3MoneroChainAccount account;
  @override
  List<Web3MoneroChainAccount> get requiredAccounts => [account];

  Web3MoneroSendTransaction._({
    required List<Web3MoneroTransactionParams> destintions,
    required this.account,
  }) : destintions = destintions.immutable;
  factory Web3MoneroSendTransaction({
    required List<Web3MoneroTransactionParams> destintions,
    required Web3MoneroChainAccount account,
  }) {
    if (destintions.isEmpty) {
      throw Web3MoneroExceptionConstant.noRecipients;
    }
    final addresses =
        destintions.map((e) => e.destination.network).toSet().length;
    if (addresses != 1) {
      throw Web3MoneroExceptionConstant.mismatchPaymentAddresses;
    }
    if (destintions.length > 1) {
      final integratedAddresses =
          destintions.map((e) => e.destination.isIntegratedAddress).length;
      if (integratedAddresses > 1) {
        throw Web3MoneroExceptionConstant.multipleIntegratedAddressNotAllowed;
      }
    }
    return Web3MoneroSendTransaction._(
        account: account, destintions: destintions);
  }

  factory Web3MoneroSendTransaction.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    return Web3MoneroSendTransaction(
        destintions: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) => Web3MoneroTransactionParams.deserialize(object: e))
            .toList(),
        account: Web3MoneroChainAccount.deserialize(
            object: values.elementAs<CborTagValue>(2)));
  }

  @override
  Web3MoneroRequestMethods get method =>
      Web3MoneroRequestMethods.sendTransaction;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          method.tag,
          CborSerializable.fromDynamic(
              destintions.map((e) => e.toCbor()).toList()),
          account.toCbor()
        ]),
        type.tag);
  }

  @override
  Future<
      Web3MoneroRequest<Web3MoneroTransactionResponse,
          Web3MoneroSendTransaction>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<IMoneroAddress, MoneroChain,
              Web3MoneroChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3MoneroRequest<Web3MoneroTransactionResponse,
            Web3MoneroSendTransaction>(
        params: this,
        authenticated: authenticated,
        chain: chain.$1,
        info: request,
        accounts: chain.$2);
  }

  @override
  Object? toJsWalletResponse(Web3MoneroTransactionResponse response) {
    return response.toCbor().encode();
  }
}
