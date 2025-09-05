import 'package:flutter/material.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/operations/transfer.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'select_utxos.dart';

class MoneroTransactionTransferWidget extends StatelessWidget {
  final MoneroTransactionTransferOperation form;
  const MoneroTransactionTransferWidget({required this.form, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      LiveFormWidget(
        field: form.totalUtxos,
        builder: (context, field, value) {
          return ContainerWithBorder(
            onRemove: () {
              context.openDialogPage(
                  child: (context) => MoneroTransactionSelectUtxos(form), "");
            },
            onRemoveIcon: AddOrEditIconWidget(form.hasUtxos),
            validate: form.hasUtxos,
            child: ConditionalWidget(
              onDeactive: (context) => Text("tap_to_choose_utxos".tr,
                  style: context.onPrimaryTextTheme.bodyMedium),
              enable: form.hasUtxos,
              onActive: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoinAndMarketPriceView(
                        balance: form.totalUtxos.value,
                        symbolColor: context.onPrimaryContainer,
                        showTokenImage: true,
                        style: context.onPrimaryTextTheme.titleMedium)
                  ]),
            ),
          );
        },
      ),
      WidgetConstant.height20,
      LiveFormWidgetList(
        field: form.recipients,
        onCreate: (context, field) =>
            LiveWidgetAddNewTransferDetails<MoneroAddress>(
                onUpdateAddresses: form.onUpdateRecipients,
                account: form.account,
                isReady: field.hasValue,
                onFilterAccount: form.filterAccount,
                multipleSelect: true),
        builder: (context, field, value) =>
            LiveWidgetTransferDetails<MoneroTransferDetails>(
                transfer: value,
                onRemove: form.onRemoveRecipients,
                onUpdateAmount: form.onUpdateRecipientAmount,
                onUpdateAmountMax: form.getMaxInput),
      ),
      WidgetConstant.height20,
      LiveFormWidget(
        field: form.remainingAmount,
        builder: (context, field, value) {
          return ContainerWithBorder(
            iconAlginment: CrossAxisAlignment.start,
            enableTap: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerWithBorder(
                    onRemove: () {
                      context
                          .selectOrSwitchAccount<IMoneroAddress>(
                              account: form.account,
                              showMultiSig: true,
                              filter: form.filterRemainAccount)
                          .then(form.onUpdateRemainingAccount);
                    },
                    onRemoveIcon:
                        Icon(Icons.edit, color: context.primaryContainer),
                    backgroundColor: context.onPrimaryContainer,
                    child: ReceiptAddressDetailsView(
                        address: value.recipient,
                        color: context.primaryContainer)),
                ContainerWithBorder(
                    validate: !value.amount.isNegative,
                    onRemoveIcon:
                        Icon(Icons.edit, color: context.primaryContainer),
                    backgroundColor: context.onPrimaryContainer,
                    child: CoinAndMarketPriceView(
                        balance: value.amount,
                        showTokenImage: true,
                        style: context.primaryTextTheme.titleMedium,
                        symbolColor: context.primaryContainer)),
              ],
            ),
          );
        },
      ),
      WidgetConstant.height20,
      TransactionFeeView(
          controller: form, onRetryFeeEstimate: form.estimateFee),
      TransactionStateSendTransaction(controller: form)
    ]);
  }
}
