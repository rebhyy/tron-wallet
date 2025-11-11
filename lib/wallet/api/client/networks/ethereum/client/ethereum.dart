import 'dart:async';

import 'package:blockchain_utils/exception/exceptions.dart';
import 'package:on_chain/on_chain.dart';
import 'package:on_chain/solidity/address/core.dart';
import 'package:on_chain_swap/on_chain_swap.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/ethereum/methods/methods.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/ethereum.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/models.dart';

class EthereumClient extends NetworkClient<
    EthWalletTransaction,
    EthereumAPIProvider,
    EthereumNetworkToken,
    ETHAddress> implements BaseSwapEthereumClient {
  EthereumClient({required this.provider, required this.network});
  @override
  final EthereumProvider provider;
  @override
  final WalletNetwork? network;
  @override
  NetworkServiceProtocol<EthereumAPIProvider> get service =>
      provider.rpc as NetworkServiceProtocol<EthereumAPIProvider>;

  Future<FeeHistorical> getHistoricalFee() async {
    final historical = await provider.request(EthereumRequestGetFeeHistory(
        blockCount: 10,
        newestBlock: BlockTagOrNumber.latest,
        rewardPercentiles: [30, 60, 99]));
    return historical!.toFee();
  }

  Future<(BigInt, bool)> getNetworkInfo() async {
    final BigInt chainId = await provider.request(EthereumRequestGetChainId());
    try {
      final eip = await provider.request(EthereumRequestGetFeeHistory(
          blockCount: 25,
          newestBlock: BlockTagOrNumber.pending,
          rewardPercentiles: [25, 50, 90]));
      return (chainId, eip != null);
    } on RPCError {
      return (chainId, false);
    }
  }

  Future<BigInt> gasPrice() async {
    final historical = await provider.request(EthereumRequestGetGasPrice());
    return historical;
  }

  Future<BigInt> estimateGasLimit(Map<String, dynamic> estimateDetails) async {
    final estimate = await provider
        .request(EthereumRequestEstimateGas(transaction: estimateDetails));
    return estimate;
  }

  Future<int> getAccountNonce(ETHAddress account) async {
    final nonce = await provider
        .request(EthereumRequestGetTransactionCount(address: account.address));
    return nonce;
  }

  Future<String> sendRawTransaction(String digest) async {
    final txID = await provider
        .request(EthereumRequestSendRawTransaction(transaction: digest));
    return txID;
  }

  Future<bool> isContract(SolidityAddress address) async {
    final code = await provider
        .request(EthereumRequestGetCode(address: address.toHex()));
    return code != null;
  }

  Future<dynamic> dynamicCall({required String method, dynamic params}) async {
    return await provider.requestDynamic(
        EthereumRequestDynamic(methodName: method, params: params));
  }

  Future<Token?> getErc20Details(SolidityAddress contractAddress) async {
    try {
      final decimal = await provider.request(RPCERC20Decimal(contractAddress,
          blockNumber: BlockTagOrNumber.latest));
      if (decimal == null) return null;
      String? name;
      String? symbol;

      final symbolQuery = await MethodUtils.call(() async =>
          await provider.request(RPCERC20Symbol(contractAddress,
              blockNumber: BlockTagOrNumber.latest)));
      if (symbolQuery.hasResult) {
        symbol = symbolQuery.result;
      }
      final nameQuery = await MethodUtils.call(() async =>
          await provider.request(RPCERC20Name(contractAddress,
              blockNumber: BlockTagOrNumber.latest)));
      if (nameQuery.hasResult) {
        name = nameQuery.result;
      }
      name ??= symbol;
      symbol ??= name;
      return Token(
          name: name ?? "Unknown",
          symbol: symbol ?? "Unknown",
          decimal: decimal);
    } on RPCError {
      return null;
    }
  }

  Future<SolidityToken?> getAccountERC20Token(
      SolidityAddress account, SolidityAddress contractAddress) async {
    final token = await getErc20Details(contractAddress);
    if (token == null) return null;
    final balance = await provider
        .request(RPCERC20TokenBalance(contractAddress.toHex(), account));
    if (contractAddress is TronAddress) {
      return TronTRC20Token.create(
          balance: balance, token: token, contractAddress: contractAddress);
    }
    return ETHERC20Token.create(
        balance: balance,
        token: token,
        contractAddress: contractAddress as ETHAddress);
  }

  @override
  Future<BigInt> getChainId() async {
    return await provider.request(EthereumRequestGetChainId());
  }

  Future<bool> checkNetworkChainId() async {
    if (network?.type != NetworkType.ethereum) return false;
    final networkChainId =
        network!.toNetwork<WalletEthereumNetwork>().coinParam.chainId;
    final chainId = await getChainId();
    return chainId == networkChainId;
  }

  @override
  Future<BigInt> getAllowance(
      {required ETHAddress contract,
      required ETHAddress owner,
      required ETHAddress spender}) async {
    final function = EthereumAbiCons.getAllowance;
    final result = await provider.request(EthereumRequestFunctionCall(
        contractAddress: contract.address,
        function: function,
        params: [owner, spender]));
    return result[0];
  }

  @override
  Future<BigInt> getBalance(ETHAddress address) async {
    return await provider
        .request(EthereumRequestGetBalance(address: address.address));
  }

  @override
  Future<BigInt> getTokenBalance(
      {required SolidityAddress address,
      required SolidityAddress contract}) async {
    return await provider
        .request(RPCERC20TokenBalance(contract.toHex(), address));
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    final receipt = await provider
        .request(EthereumRequestGetTransactionReceipt(transactionHash: txId));
    if (receipt == null) return WalletTransactionStatus.unknown;
    final status = receipt.status;
    if (status != null && !status) {
      return WalletTransactionStatus.failed;
    }
    return WalletTransactionStatus.block;
  }

  @override
  Future<TransactionReceipt> trackTransaction(
      {required String transactionId,
      Duration timeout = const Duration(minutes: 5),
      Duration periodicTimeOut = const Duration(seconds: 3)}) async {
    Timer? timer;
    try {
      final Completer<TransactionReceipt> completer =
          Completer<TransactionReceipt>();
      timer = Timer.periodic(periodicTimeOut, (t) async {
        final receipt = await provider
            .request(EthereumRequestGetTransactionReceipt(
                transactionHash: transactionId))
            .catchError((e, s) {
          return null;
        });
        if (receipt != null && !completer.isCompleted) {
          completer.complete(receipt);
        }
      });
      final receipt = await completer.future.timeout(timeout);
      return receipt;
    } on TimeoutException {
      throw ApiProviderException.message("transaction_confirmation_failed");
    } finally {
      timer?.cancel();
      timer = null;
    }
  }

  @override
  Future<SwapEthereumAccountAssetBalance> getAccountsAssetBalance(
      ETHSwapAsset asset, ETHAddress account) async {
    if (asset.isContract && asset.contractAddress == null) {
      throw ApiProviderExceptionConst.unexpectedRequestData;
    }

    return SwapEthereumAccountAssetBalance(
        address: account,
        balance: asset.isNative
            ? await getBalance(account)
            : await getTokenBalance(
                address: account, contract: asset.contractAddress!),
        asset: asset);
  }

  @override
  Stream<List<EthereumNetworkToken>> getAccountTokensStream(
      ETHAddress address) {
    final controller = StreamController<List<EthereumNetworkToken>>();

    void close() {
      if (!controller.isClosed) controller.close();
    }

    controller.onListen = () => close();
    controller.onCancel = close;
    return controller.stream;
  }

  @override
  Future<BigInt?> getBlockHeight() async {
    final block = await provider.request(EthereumRequestGetBlockNumber());
    return BigInt.from(block);
  }

  @override
  Future<bool> initSwapClient() async {
    final init = await this.init();
    if (!init) {
      throw ApiProviderExceptionConst.initializeClientFailed;
    }
    return true;
  }

  @override
  Future<bool> onInit() async {
    if (network?.type == NetworkType.ethereum) {
      final result = await MethodUtils.call(() async {
        final BigInt chainId =
            await provider.request(EthereumRequestGetChainId());
        return chainId;
      });
      return result.hasResult &&
          result.result ==
              network?.toNetwork<WalletEthereumNetwork>().coinParam.chainId;
    }
    return false;
  }

  @override
  NetworkType get networkType => NetworkType.ethereum;
}
