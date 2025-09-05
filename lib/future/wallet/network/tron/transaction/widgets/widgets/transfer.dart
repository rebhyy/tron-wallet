import 'package:flutter/material.dart';
import 'package:on_chain/tron/src/models/contract/base_contract/transaction_type.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/token_details_view.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/future/wallet/network/tron/transaction/operations/transfer/transfer.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'fee.dart';

class TronTransactionTransferWidget extends StatelessWidget {
  final TronTransactionBaseTransferOperation form;
  final TronToken? token;
  const TronTransactionTransferWidget(
      {required this.form, this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      ConditionalWidget(
          enable: form.transactionType ==
                  TransactionContractType.transferAssetContract ||
              form.transactionType ==
                  TransactionContractType.triggerSmartContract,
          onActive: (context) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("token_transfer".tr,
                      style: context.textTheme.titleMedium),
                  WidgetConstant.height8,
                  TokenDetailsView(token: form.transferToken),
                  WidgetConstant.height20,
                ]);
          }),
      LiveFormWidgetReceiverAddress(
          onUpdateAddress: form.onUpdateAddress,
          field: form.receipt,
          onFilterAccount: form.filterAccount,
          account: form.account),
      WidgetConstant.height20,
      LiveFormWidgetAmount(
          field: form.amount,
          onUpdateAmount: form.onUpdateAmount,
          onUpdateAmountMax: () => form.getMaxInput()),
      WidgetConstant.height20,
      LiveFormWidgetMemo(
          field: form.memo,
          onUpdateMemo: form.onUpdateMemo,
          onRemoveMemo: form.onRemoveMemo),
      WidgetConstant.height20,
      TronTransactionFeeDataView(controller: form),
      ConditionalWidget(
        enable: form.isTrc20Transfer,
        onActive: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetConstant.height20,
              LiveFormWidgetAmount(
                field: form.feeLimit,
                onUpdateAmount: (amount, max) => form.onUpdateFeeLimit(amount),
                onUpdateAmountMax: form.getMaxFeeInput,
              ),
            ],
          );
        },
      ),
      TransactionStateSendTransaction(controller: form)
    ]);
  }
}
