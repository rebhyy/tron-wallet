import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain/ada/src/models/transaction/transaction/transaction.dart';
import 'package:on_chain/ada/src/models/transaction/witnesses/models/transaction_witness_set.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/permission/permission.dart';

class Web3ADASignTransactionResponse with CborSerializable {
  final TransactionWitnessSet witness;
  final String txId;
  final String? error;
  Web3ADASignTransactionResponse(
      {required this.txId, required this.witness, required this.error});
  factory Web3ADASignTransactionResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);

    return Web3ADASignTransactionResponse(
        txId: values.valueAs(0),
        witness: TransactionWitnessSet.fromCborBytes(values.valueAs(1)),
        error: values.valueAs(2));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [txId, CborBytesValue(witness.serialize()), error]),
        CborTagsConst.defaultTag);
  }
}

class Web3ADASignTransactionsResponse with CborSerializable {
  final List<Web3ADASignTransactionResponse> witnesses;
  Web3ADASignTransactionsResponse(
      {required List<Web3ADASignTransactionResponse> witnesses})
      : witnesses = witnesses.immutable;
  factory Web3ADASignTransactionsResponse.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3ADASignTransactionsResponse(
        witnesses: values
            .elementAsListOf<CborTagValue>(0)
            .map((e) => Web3ADASignTransactionResponse.deserialize(object: e))
            .toList());
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue.definite([
          CborListValue.definite(witnesses.map((e) => e.toCbor()).toList())
        ]),
        CborTagsConst.defaultTag);
  }
}

class Web3ADASignTransactionParams with CborSerializable {
  final ADATransaction transaction;
  final bool partialSign;
  Web3ADASignTransactionParams(
      {required this.transaction, required this.partialSign});
  factory Web3ADASignTransactionParams.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CborTagsConst.defaultTag);
    return Web3ADASignTransactionParams(
        transaction: ADATransaction.fromCborBytes(values.valueAs(0)),
        partialSign: values.valueAs(1));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborBytesValue(transaction.serialize()),
          partialSign,
        ]),
        CborTagsConst.defaultTag);
  }
}

class Web3ADASignTransaction
    extends Web3ADARequestParam<Web3ADASignTransactionsResponse> {
  final List<Web3ADASignTransactionParams> transactions;
  final List<Web3ADAChainAccount> accounts;

  @override
  List<Web3ADAChainAccount> get requiredAccounts => accounts;

  Web3ADASignTransaction._({
    required List<Web3ADAChainAccount> accounts,
    required List<Web3ADASignTransactionParams> transactions,
    required this.method,
  })  : accounts = accounts.immutable,
        transactions = transactions.immutable;
  factory Web3ADASignTransaction(
      {required List<Web3ADAChainAccount> accounts,
      required Web3NetworkRequestMethods method,
      required List<Web3ADASignTransactionParams> transactions}) {
    if (accounts.isEmpty || transactions.isEmpty) {
      throw Web3RequestExceptionConst.internalError;
    }
    switch (method) {
      case Web3ADARequestMethods.signTx:
      case Web3ADARequestMethods.submitTx:
      case Web3ADARequestMethods.submitUnsignedTx:
        if (transactions.length > 1) {
          throw Web3RequestExceptionConst.internalError;
        }
        break;
      case Web3ADARequestMethods.signTransaction:
      case Web3ADARequestMethods.signAndSendTransaction:
      case Web3ADARequestMethods.submitTxs:
      case Web3ADARequestMethods.signTxs:
        break;
      default:
        throw Web3RequestExceptionConst.internalError;
    }
    return Web3ADASignTransaction._(
        transactions: transactions, accounts: accounts, method: method.cast());
  }

  factory Web3ADASignTransaction.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    return Web3ADASignTransaction(
        method: Web3NetworkRequestMethods.fromTag(values.valueAs(0)),
        transactions: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) => Web3ADASignTransactionParams.deserialize(object: e))
            .toList(),
        accounts: values
            .elementAsListOf<CborTagValue>(2)
            .map((e) => Web3ADAChainAccount.deserialize(object: e))
            .toList());
  }

  @override
  final Web3ADARequestMethods method;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborBytesValue(method.tag),
          CborListValue.definite(transactions.map((e) => e.toCbor()).toList()),
          CborSerializable.fromDynamic(accounts.map((e) => e.toCbor()).toList())
        ]),
        type.tag);
  }

  @override
  Future<
      Web3ADARequest<Web3ADASignTransactionsResponse,
          Web3ADASignTransaction>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<ICardanoAddress, ADAChain,
              Web3ADAChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3ADARequest<Web3ADASignTransactionsResponse,
            Web3ADASignTransaction>(
        params: this,
        authenticated: authenticated,
        chain: chain.$1,
        info: request,
        accounts: chain.$2);
  }

  @override
  Object? toJsWalletResponse(Web3ADASignTransactionsResponse response) {
    return response.toCbor().encode();
  }
}
