part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

base mixin XRPChainController on Chain<
    RippleAPIProvider,
    RippleNetworkParams,
    XRPAddress,
    RippleIssueToken,
    RippleNFToken,
    IXRPAddress,
    WalletXRPNetwork,
    XRPClient,
    XRPChainConfig,
    XRPWalletTransaction,
    RippleContact,
    RippleNewAddressParams> {
  Future<void> _getAccountTxes(IXRPAddress address) async {
    await onClient(onConnect: (client) async {
      final txes = await client.getAccountTxes(
          address: address.networkAddress,
          ledger: address._lastUpdateLedgerIndex ?? -1);
      address._setLastUpdateLedgerIndex(txes.latestLedger);
      final receivedTxes = txes.txes
          .where((e) =>
              e.transaction.transaction.account !=
              address.networkAddress.address)
          .toList();
      for (final i in receivedTxes) {
        WalletTransactionAmount? amount;
        final tx = i.transaction.transaction;
        if (tx.transactionType == SubmittableTransactionType.payment) {
          final payment = tx.cast<Payment>();
          if (payment.amount.type == AmountType.native) {
            amount = WalletTransactionIntegerAmount(
                amount: (payment.amount as XRPAmount).value, network: network);
          } else if (payment.amount.type == AmountType.issue) {
            final currencyAmount = (payment.amount as IssuedCurrencyAmount);
            NonDecimalToken? token = address.tokens
                .firstWhereNullable((e) =>
                    e.issuer == currencyAmount.issuer &&
                    e.assetCode == currencyAmount.currency)
                ?.token;
            token ??= NonDecimalToken(
                name: currencyAmount.currency, symbol: currencyAmount.currency);
            amount = WalletTransactionDecimalsAmount(
                amount: currencyAmount.value, token: token);
          }
        }
        XRPAddress sender = XRPAddress(tx.account);
        if (tx.sourceTag != null) {
          sender = XRPAddress(sender.toXAddress(
              tag: tx.sourceTag,
              isTestnet: !network.coinParam.chainType.isMainnet));
        }
        final xrpTx = XRPWalletTransaction(
            txId: i.txId,
            totalOutput: amount,
            time: i.ledgerTime,
            type: WalletTransactionType.receive,
            status: i.ledgerTime == null
                ? WalletTransactionStatus.pending
                : WalletTransactionStatus.block,
            network: network,
            inputs: [
              XRPWalletTransactionOperationInput(
                  address: sender, operation: tx.transactionType.value)
            ]);
        saveTransaction(address: address, transaction: xrpTx);
      }
    });
  }
}
