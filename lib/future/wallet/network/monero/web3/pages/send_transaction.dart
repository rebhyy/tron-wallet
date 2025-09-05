import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/widgets/select_utxos.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/web3/operations/send_transaction.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';

class Web3MoneroSignTransactionStateView extends StatelessWidget {
  final WebMoneroSignTransactionStateController controller;
  const Web3MoneroSignTransactionStateView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final transactionData = controller.transactionData;
    return MultiSliver(children: [
      LiveFormWidget(
        field: controller.totalUtxos,
        builder: (context, field, value) {
          return ContainerWithBorder(
            onRemove: () {
              context.openDialogPage(
                  child: (context) => MoneroTransactionSelectUtxos(controller),
                  "");
            },
            onRemoveIcon: AddOrEditIconWidget(controller.hasUtxos),
            validate: controller.hasUtxos,
            child: ConditionalWidget(
              onDeactive: (context) => Text("tap_to_choose_utxos".tr,
                  style: context.onPrimaryTextTheme.bodyMedium),
              enable: controller.hasUtxos,
              onActive: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CoinAndMarketPriceView(
                        balance: controller.totalUtxos.value,
                        symbolColor: context.onPrimaryContainer,
                        showTokenImage: true,
                        style: context.onPrimaryTextTheme.titleMedium)
                  ]),
            ),
          );
        },
      ),
      WidgetConstant.height20,
      Text("recipients".tr, style: context.onPrimaryTextTheme.titleMedium),
      WidgetConstant.height8,
      ...List.generate(transactionData.destinations.length, (index) {
        final re = transactionData.destinations[index];
        return ContainerWithBorder(
          child: Column(children: [
            ContainerWithBorder(
              backgroundColor: context.onPrimaryContainer,
              child: ReceiptAddressDetailsView(
                  address: re.recipient, color: context.primaryContainer),
            ),
            ContainerWithBorder(
              backgroundColor: context.onPrimaryContainer,
              child: CoinAndMarketPriceView(
                  balance: re.amount,
                  style: context.primaryTextTheme.titleMedium,
                  showTokenImage: true,
                  symbolColor: context.primaryContainer),
            )
          ]),
        );
      }),
      WidgetConstant.height20,
      LiveFormWidget(
        field: controller.remainingAmount,
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
                              account: controller.account,
                              showMultiSig: true,
                              filter: controller.filterRemainAccount)
                          .then(controller.onUpdateRemainingAccount);
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
      TransactionFeeWidget(
          fee: controller.txFee,
          onRetryFeeEstimate: controller.estimateFee,
          getMaxFeeInput: controller.maxFeeInput),
      Web3StateAcceptRequestView(
          controller: controller, title: "send_transaction".tr),
    ]);
  }
}
