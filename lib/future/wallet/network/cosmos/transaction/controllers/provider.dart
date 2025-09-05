import 'package:blockchain_utils/exception/exception/rpc_error.dart';
import 'package:blockchain_utils/utils/numbers/rational/big_rational.dart';
import 'package:cosmos_sdk/cosmos_sdk.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/wallet/network/cosmos/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/network/cosmos/web3/types/fee.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/networks.dart';
import 'package:on_chain_wallet/wallet/constant/networks/cosmos.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/cosmos/models/network_types.dart';
import 'package:on_chain_wallet/wallet/models/token/token/token.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cosmos/constant/constants/exception.dart';

mixin CosmosTransactionApiController on DisposableMixin {
  CosmosClient get client;
  WalletCosmosNetwork get network;

  Future<CosmosTransactionRequirment> getTransactionRequirment({
    required ICosmosAddress owner,
    Fee? fee,
  }) async {
    final payerAddress = fee?.payer ?? owner.networkAddress;
    bool ownerIsPayer = owner.networkAddress == payerAddress;
    List<Coin> balances = [];
    final payerAccount = await client.getBaseAccount(payerAddress);
    BigInt? fixedFee;
    if (network.coinParam.networkType == CosmosNetworkTypes.thorAndForked) {
      final fee = await MethodUtils.call(() async {
        final networkConst = await client.getThorNodeConstants();
        return BigInt.from(networkConst.nativeTransactionFee);
      });
      assert(fee.hasResult,
          "failed to fetch ${network.networkName} native trasaction fee: ${fee.localizationError}");
      if (fee.hasResult) {
        fixedFee = fee.result;
      } else {
        fixedFee = network.coinParam.getFeeToken().averageGasPrice.balance;
      }
    }
    BigRational? ethermintTxFee;
    if (network.coinParam.networkType.isEthermint) {
      final fee = await MethodUtils.call(() {
        return client.getEthermintBaseFee();
      });
      assert(fee.hasResult,
          "failed to fetch ${network.networkName} base gas fee: ${fee.localizationError}");
      if (fee.hasResult) {
        ethermintTxFee = fee.result;
      } else {
        ethermintTxFee = BigRational.parseDecimal(
            network.coinParam.getFeeToken().averageGasPrice.price);
      }
    }
    if (payerAccount != null) {
      balances = await client.getAddressCoins(payerAddress);
    }
    final List<CW20Token> feeTokens =
        List.generate(network.coinParam.feeTokens.length, (i) {
      final token = network.coinParam.feeTokens[i];
      CW20Token? feeToken;
      Token viewToken = token.token;
      if (ownerIsPayer) {
        viewToken = owner.tokens
                .firstWhereOrNull((e) => e.denom == token.denom)
                ?.token ??
            viewToken;
      }

      return feeToken ??
          CW20Token.create(
              balance: balances
                      .firstWhereOrNull((e) => e.denom == token.denom)
                      ?.amount ??
                  BigInt.zero,
              token: viewToken,
              denom: token.denom);
    });
    if (fee != null) {
      for (final i in fee.amount) {
        final token = feeTokens.firstWhereOrNull((e) => e.denom == i.denom);
        if (token == null) {
          try {
            final tokenMetadata = await client.getTokenMetadata(i.denom);
            feeTokens.add(tokenMetadata);
          } on RPCError catch (e) {
            if (e.errorCode == CosmosConst.accountNotFoundErrorCode) {
              throw Web3CosmosExceptionConstant.feeCoinNotFound;
            }
            throw Web3RequestExceptionConst.fromException(e);
          } catch (e) {
            throw Web3RequestExceptionConst.fromException(e);
          }
        }
      }
    }

    return CosmosTransactionRequirment(
        account: payerAccount,
        feeTokens: feeTokens,
        fixedNativeGas: fixedFee,
        ethermintTxFee: ethermintTxFee);
  }

  Future<CosmosWeb3SimulateInfos> simulateWeb3Transaction(List<int> txBytes,
      {List<CosmosMessage> txMessages = const []}) async {
    final r = await client.simulateTx(txBytes);
    return CosmosWeb3SimulateInfos(simulate: r, txMessages: txMessages);
  }
}
