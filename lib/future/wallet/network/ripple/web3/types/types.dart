import 'package:on_chain_wallet/app/dev/logger.dart';
import 'package:on_chain_wallet/future/wallet/controller/controller.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/web3/operations/send_transaction.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/web3/operations/sign_message.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/core/web3.dart';
import 'package:on_chain_wallet/future/wallet/web3/core/state.dart';
import 'package:on_chain_wallet/wallet/api/client/client.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/others/others.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/xrp.dart';
import 'package:on_chain_wallet/wallet/web3/web3.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

enum XRPWeb3SigningMode {
  full,
  part;

  bool get isFull => this == full;
}

abstract class Web3XRPStateController<RESPONSE, CLIENT extends XRPClient?,
        T extends Web3XRPRequestParam<RESPONSE>>
    extends Web3StateController<
        RESPONSE,
        XRPAddress,
        WalletXRPNetwork,
        XRPClient,
        CLIENT,
        IXRPAddress,
        XRPChain,
        Web3XRPChainAccount,
        T,
        Web3XRPRequest<RESPONSE, T>,
        Web3RequestResponseData<RESPONSE>,
        XRPWalletTransaction> {
  Web3XRPStateController(
      {required super.walletProvider, required super.request});

  static BaseWeb3StateController findController(
      {required Web3NetworkRequest request,
      required WalletProvider walletProvider}) {
    if (request is! Web3XRPRequest) {
      throw Web3RequestExceptionConst.internalError;
    }
    appLogger.debug(
        runtime: "Web3XRPStateController",
        functionName: "findController",
        msg: request.params.method.name);
    switch (request.params.method) {
      case Web3XRPRequestMethods.signMessage:
        return Web3XRPSignMessageStateController(
            walletProvider: walletProvider, request: request.cast());
      case Web3XRPRequestMethods.sendTransaction:
      case Web3XRPRequestMethods.signTransaction:
        return WebXRPSendTransactionStateController(
            walletProvider: walletProvider, request: request.cast());
      default:
        throw Web3RequestExceptionConst.methodDoesNotExist;
    }
  }
}

abstract class BaseWeb3XRPTransactionStateController<
        RESPONSE,
        T extends Web3XRPRequestParam<RESPONSE>,
        E extends IWeb3XRPTransactionData>
    extends Web3TransactionStateController<
        RESPONSE,
        XRPAddress,
        IXRPAddress,
        XRPClient,
        XRPClient,
        WalletXRPNetwork,
        XRPChain,
        Web3XRPChainAccount,
        T,
        Web3XRPRequest<RESPONSE, T>,
        E,
        IWeb3XRPTransaction<E>,
        IWeb3XRPSignedTransaction<E>,
        XRPWalletTransaction,
        SubmitTransactionSuccess<IWeb3XRPSignedTransaction<E>>> {
  BaseWeb3XRPTransactionStateController(
      {required super.walletProvider, required super.request});
}

abstract class IWeb3XRPTransactionData extends ITransactionData {
  final SubmittableTransaction transaction;
  final String content;
  final XRPWeb3SigningMode signingMode;
  final List<XRPLMemo> memos;
  final XRPWeb3TransactionInfo? info;
  const IWeb3XRPTransactionData(
      {required this.transaction,
      required this.content,
      required this.signingMode,
      required this.memos,
      required this.info});
}

class IWeb3XRPTransactionRawData extends IWeb3XRPTransactionData {
  IWeb3XRPTransactionRawData(
      {required super.transaction,
      required super.content,
      required super.signingMode,
      required super.memos,
      required super.info});
}

class IWeb3XRPTransaction<TXDATA extends IWeb3XRPTransactionData>
    extends ITransaction<TXDATA, IXRPAddress> {
  const IWeb3XRPTransaction(
      {required super.account, required super.transactionData});
}

class IWeb3XRPSignedTransaction<TXDATA extends IWeb3XRPTransactionData>
    extends ISignedTransaction<IWeb3XRPTransaction<TXDATA>,
        SubmittableTransaction> {
  IWeb3XRPSignedTransaction(
      {required super.transaction,
      required super.signatures,
      required super.finalTransactionData,
      required this.signature,
      required this.multiSignature});
  final XRPLSignature? signature;
  final List<XRPLSigners>? multiSignature;
}

abstract class XRPWeb3TransactionInfo {
  final SubmittableTransactionType type;
  const XRPWeb3TransactionInfo({required this.type});
}

class XRPWeb3TransactionInfoPayment extends XRPWeb3TransactionInfo {
  final ReceiptAddress<XRPAddress> recipient;
  final BalanceCore amount;
  const XRPWeb3TransactionInfoPayment(
      {required this.recipient, required this.amount})
      : super(type: SubmittableTransactionType.payment);
}
