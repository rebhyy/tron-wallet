import 'package:blockchain_utils/helper/helper.dart';
import 'package:on_chain_wallet/app/dev/logger.dart';
import 'package:on_chain_wallet/future/wallet/controller/controller.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/web3/operations/import_network.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/web3/operations/sign_message.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/web3/operations/sign_transaction.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/core/web3.dart';
import 'package:on_chain_wallet/future/wallet/web3/core/state.dart';
import 'package:on_chain_wallet/wallet/api/client/client.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/substrate/models/metadata_fields.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/substrate.dart';
import 'package:on_chain_wallet/wallet/web3/web3.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

abstract class Web3SubstrateStateController<
        RESPONSE,
        CLIENT extends SubstrateClient?,
        T extends Web3SubstrateRequestParam<RESPONSE>>
    extends Web3StateController<
        RESPONSE,
        BaseSubstrateAddress,
        WalletSubstrateNetwork,
        SubstrateClient,
        CLIENT,
        ISubstrateAddress,
        SubstrateChain,
        Web3SubstrateChainAccount,
        T,
        Web3SubstrateRequest<RESPONSE, T>,
        Web3RequestResponseData<RESPONSE>,
        SubstrateWalletTransaction> {
  Web3SubstrateStateController(
      {required super.walletProvider, required super.request});

  static BaseWeb3StateController findController(
      {required Web3NetworkRequest request,
      required WalletProvider walletProvider}) {
    if (request is! Web3SubstrateRequest) {
      throw Web3RequestExceptionConst.internalError;
    }
    appLogger.debug(
        runtime: "Web3SubstrateStateController",
        functionName: "findController",
        msg: request.params.method.name);
    switch (request.params.method) {
      case Web3SubstrateRequestMethods.signMessage:
        return Web3SubstrateSignMessageStateController(
            walletProvider: walletProvider, request: request.cast());
      case Web3SubstrateRequestMethods.signTransaction:
        return WebSubstrateSignTransactionStateController(
            walletProvider: walletProvider, request: request.cast());
      case Web3SubstrateRequestMethods.addSubstrateChain:
        return Web3SubstrateImportOrUpdateNetworkStateController(
            walletProvider: walletProvider, request: request.cast());
      default:
        throw Web3RequestExceptionConst.methodDoesNotExist;
    }
  }
}

abstract class BaseWeb3SubstrateTransactionStateController<
        RESPONSE,
        T extends Web3SubstrateRequestParam<RESPONSE>,
        E extends IWeb3SubstrateTransactionData>
    extends Web3TransactionStateController<
        RESPONSE,
        BaseSubstrateAddress,
        ISubstrateAddress,
        SubstrateClient,
        SubstrateClient,
        WalletSubstrateNetwork,
        SubstrateChain,
        Web3SubstrateChainAccount,
        T,
        Web3SubstrateRequest<RESPONSE, T>,
        E,
        IWeb3SubstrateTransaction<E>,
        IWeb3SubstrateSignedTransaction<E>,
        SubstrateWalletTransaction,
        SubmitTransactionSuccess<IWeb3SubstrateSignedTransaction<E>>> {
  BaseWeb3SubstrateTransactionStateController(
      {required super.walletProvider, required super.request});
}

abstract class IWeb3SubstrateTransactionData extends ITransactionData {}

class IWeb3SubstrateTransactionRawData extends IWeb3SubstrateTransactionData {
  final ExtrinsicPayloadInfo extrinsicPayloadInfo;
  final List<SubstrateKnownCallMethods> methods;
  IWeb3SubstrateTransactionRawData(
      {required this.extrinsicPayloadInfo,
      required List<SubstrateKnownCallMethods> methods})
      : methods = methods.immutable;
}

class IWeb3SubstrateTransaction<TXDATA extends IWeb3SubstrateTransactionData>
    extends ITransaction<TXDATA, ISubstrateAddress> {
  const IWeb3SubstrateTransaction(
      {required super.account, required super.transactionData});
}

class IWeb3SubstrateSignedTransaction<
        TXDATA extends IWeb3SubstrateTransactionData>
    extends ISignedTransaction<IWeb3SubstrateTransaction<TXDATA>,
        ExtrinsicInfo> {
  IWeb3SubstrateSignedTransaction({
    required super.transaction,
    required super.signatures,
    required super.finalTransactionData,
  });
}
