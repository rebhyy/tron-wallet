import 'package:blockchain_utils/utils/numbers/rational/big_rational.dart';
import 'package:cosmos_sdk/cosmos_sdk.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/constant/const.dart';
import 'package:on_chain_wallet/future/wallet/network/cosmos/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/wallet/constant/networks/cosmos.dart';
import 'package:on_chain_wallet/wallet/models/token/token/token.dart';

mixin CosmosTransactionFeeController on BaseCosmosTransactionController {
  final Cancelable _cancelable = Cancelable();
  final _lock = SynchronizedLock();

  @override
  late final CosmosTransactionFeeData txFee = CosmosTransactionFeeData(
      select: CosmosTransactionFee(
          token: network.token, denom: network.coinParam.denom),
      feeToken: network.token,
      denom: network.coinParam.denom,
      gasLimit: CosmosConst.defaultGasLimit,
      messages: 1);
  CosmosTransactionRequirment get transactionRequirment;

  @override
  BigInt getMaxFeeInput() {
    final token = transactionRequirment.feeTokens
        .firstWhere((e) => e.denom == txFee.denom);
    return token.balance.balance;
  }

  void _setupFees(String denom,
      {Token? token, int? messages, BigInt? gasUsed, String? error}) {
    gasUsed ??= txFee.gasLimit;
    messages ??= txFee.messages;
    final feeToken = network.coinParam.getFeeToken(denom: denom);
    token ??= feeToken.token;

    List<CosmosTransactionFee> fees = [];
    if (isThorChain) {
      BigInt fee = transactionRequirment.fixedNativeGas!;
      if (messages > 1) {
        fee = fee * BigInt.from(messages);
      }
      fees.add(_buildFixedFee(
          denom: denom, gasLimit: gasUsed, amount: fee, error: error));
    } else if (network.coinParam.networkType.isEthermint) {
      final gasPrice = transactionRequirment.ethermintTxFee!;
      fees.add(_buildDynamicFee(
          gasUsed: gasUsed,
          gasPrice: gasPrice,
          denom: denom,
          feeToken: token,
          error: error));
    } else {
      final slow = feeToken.lowGasPrice;
      final high = feeToken.highGasPrice;
      final avg = feeToken.averageGasPrice;
      if (slow != null) {
        fees.add(_buildDynamicFee(
            gasUsed: gasUsed,
            gasPrice: BigRational.parseDecimal(slow.price),
            denom: denom,
            feeToken: token,
            feeType: TxFeeTypes.slow,
            error: error));
      }
      fees.add(_buildDynamicFee(
          gasUsed: gasUsed,
          gasPrice: BigRational.parseDecimal(avg.price),
          denom: denom,
          feeToken: token,
          error: error));
      if (high != null) {
        fees.add(_buildDynamicFee(
            gasUsed: gasUsed,
            gasPrice: BigRational.parseDecimal(high.price),
            denom: denom,
            feeToken: token,
            feeType: TxFeeTypes.high,
            error: error));
      }
    }
    txFee.updateCosmosFeeToken(
        token: token,
        fees: fees,
        denom: denom,
        gasLimit: gasUsed,
        messages: messages);
  }

  Future<(BigInt, int)> simulateFee() async {
    final transaction = await buildTransaction();
    final signedTransaction =
        await signTransaction(transaction, fakeSignature: true);
    final tx = Tx(
        body: transaction.transaction,
        authInfo: signedTransaction.auth,
        signatures: [CryptoConst.fakeEd25519Signature]);
    final simulate = await client.simulateTx(tx.toBuffer());
    return (
      simulate.gasInfo.gasUsed,
      transaction.transactionData.messages.length
    );
  }

  @override
  Future<void> estimateFee() async {
    _cancelable.cancel();
    await _lock.synchronized(() async {
      _setupFees(txFee.denom);
      txFee.setPending();
      final fee = await MethodUtils.call(() async => await simulateFee());
      if (fee.isCancel) return;
      if (fee.hasError) {
        _setupFees(txFee.denom, error: fee.localizationError);
        return;
      }
      _setupFees(txFee.denom,
          gasUsed: fee.result.$1,
          token: txFee.feeToken,
          messages: fee.result.$2);
    });
  }

  CosmosTransactionFee _buildFixedFee(
      {required String denom,
      BigInt? gasLimit,
      BigInt? amount,
      String? error}) {
    return CosmosTransactionFee(
        token: txFee.feeToken,
        gasLimit: gasLimit,
        fee: amount ?? BigInt.from(10000),
        error: error,
        denom: denom);
  }

  CosmosTransactionFee _buildDynamicFee(
      {BigInt? gasUsed,
      required BigRational gasPrice,
      required String denom,
      required Token feeToken,
      String? error,
      TxFeeTypes feeType = TxFeeTypes.normal}) {
    final gp = (BigRational(gasUsed ?? CosmosConst.defaultGasLimit) *
        CosmosConst.feeMultiplier);

    final fee = (gp * gasPrice).ceil();
    return CosmosTransactionFee(
        token: feeToken,
        fee: fee.toBigInt(),
        gasLimit: gp.toBigInt(),
        type: feeType,
        error: error,
        denom: denom);
  }

  Future<void> initFee() async {
    final token = transactionRequirment.feeTokens.firstWhere(
        (e) => e.denom == network.coinParam.denom,
        orElse: () => transactionRequirment.feeTokens.first);
    _setupFees(token.denom, token: token.token);
  }

  void setManualFee(CosmosTransactionFee? fee) {
    if (fee == null) return;
    _cancelable.cancel();
    _lock.synchronized(() async {
      _setupFees(fee.denom);
      txFee.setManualFee(fee);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelable.cancel();
    txFee.dispose();
  }
}
