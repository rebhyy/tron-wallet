import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/pages/fee.dart';

class Web3SuiSignTransactionStateView extends StatelessWidget {
  final WebSuiSignTransactionStateController controller;
  const Web3SuiSignTransactionStateView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final transactionData = controller.transactionData;
    return MultiSliver(children: [
      Text("transaction_content".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      ContainerWithBorder(
        onRemove: () {
          context.openDialogPage(
            "transaction_content".tr,
            child: (context) => APPTextView(
                text: transactionData.txContent,
                title: "transaction_content".tr),
          );
        },
        onRemoveWidget: Icon(Icons.code, color: context.onPrimaryContainer),
        child: Text("content".tr),
      ),
      WidgetConstant.height20,
      ConditionalWidget(
          enable: transactionData.owner != null,
          onActive: (context) =>
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ReceiptAddressView(
                    address: transactionData.owner,
                    title: "transaction_owner".tr),
              ])),
      ConditionalWidget(
          enable: transactionData.feePayer != null,
          onActive: (context) =>
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ReceiptAddressView(
                    address: transactionData.feePayer,
                    title: "transaction_fee_payer".tr),
                WidgetConstant.height20
              ])),
      APPStreamBuilder(
        value: controller.txFee.notifier,
        builder: (context, _) {
          final fee = controller.txFee;
          return ConditionalWidget(
            enable: fee.status != TxFeeStatus.idle,
            onActive: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("simulate_transaction".tr,
                    style: context.textTheme.titleMedium),
                WidgetConstant.height8,
                Shimmer(
                    onActive: (enable, context) {
                      return ContainerWithBorder(
                          padding: EdgeInsets.zero,
                          onRemove: () {},
                          enableTap: false,
                          onRemoveWidget: ConditionalWidget(
                              enable: fee.proccessed &&
                                  fee.fee.simulateContent != null,
                              onActive: (context) => IconButton(
                                  onPressed: () {
                                    final content = fee.fee.simulateContent;
                                    if (content == null) return;
                                    context.openDialogPage(
                                        "simulate_content".tr,
                                        child: (context) => APPTextView(
                                            text: content,
                                            title: "simulate_content".tr));
                                  },
                                  icon: Icon(Icons.code,
                                      color: context.onPrimaryContainer))),
                          child: APPExpansionListTile(
                            title: ConditionalWidget(
                                enable: fee.proccessed,
                                onDeactive: (context) => Text(
                                    "transaction_simulate_please_wait".tr,
                                    style:
                                        context.onPrimaryTextTheme.bodyMedium),
                                onActive: (context) => Text(
                                    fee.fee.hasError
                                        ? "transaction_simulation_failed".tr
                                        : "transaction_simulation_success".tr,
                                    style:
                                        context.onPrimaryTextTheme.bodyMedium)),
                            trailing: fee.fee.hasError
                                ? null
                                : WidgetConstant.sizedBox,
                            children: [
                              ErrorTextContainer(error: fee.fee.error)
                            ],
                          )

                          // APPAnimatedSwitcher<
                          //     TxFeeStatus>(enable: fee.status, widgets: {
                          //   TxFeeStatus.pending: (context) => FullWidthWrapper(
                          //         child: Text(
                          //             "transaction_simulate_please_wait".tr,
                          //             style:
                          //                 context.onPrimaryTextTheme.bodyMedium),
                          //       ),
                          //   TxFeeStatus.process: (context) =>
                          //       ,
                          // }),
                          );
                    },
                    enable: !controller.txFee.isPending),
              ],
            ),
          );
        },
      ),
      APPStreamBuilder(
        value: controller.balanceChanged,
        builder: (context, value) {
          return APPAnimated(
              isActive: true,
              onActive: (context) =>
                  _BalanceChangedView(value, key: ValueKey(value)));
        },
      ),
      WidgetConstant.height20,
      TransactionFeeWidget(
          fee: controller.txFee,
          getMaxFeeInput: () => BigInt.zero,
          onRetryFeeEstimate: controller.estimateFee),
      Web3StateAcceptRequestView(
          controller: controller, title: "sign_transaction".tr),
    ]);
  }
}

class _BalanceChangedView extends StatelessWidget {
  const _BalanceChangedView(this.changedBalance, {super.key});
  final List<SuiWeb3AccountChangeBalance>? changedBalance;
  @override
  Widget build(BuildContext context) {
    if (changedBalance == null) return WidgetConstant.sizedBox;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetConstant.height20,
        Text("balance_changes".tr, style: context.textTheme.titleMedium),
        WidgetConstant.height8,
        ContainerWithBorder(
          child: APPExpansionListTile(
            tilePadding: EdgeInsets.zero,
            title: Text("balance_changes".tr,
                style: context.onPrimaryTextTheme.bodyMedium),
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  physics: WidgetConstant.noScrollPhysics,
                  itemBuilder: (context, index) {
                    final balance = changedBalance![index];
                    return ContainerWithBorder(
                      backgroundColor: context.onPrimaryContainer,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("owner".tr,
                                style: context.primaryTextTheme.titleMedium),
                            WidgetConstant.height8,
                            ContainerWithBorder(
                              child: ConditionalWidget(
                                enable: balance.ownerAddres != null,
                                onActive: (context) {
                                  return ReceiptAddressDetailsView(
                                      address: balance.ownerAddres!,
                                      color: context.onPrimaryContainer);
                                },
                                onDeactive: (context) {
                                  return Text(balance.owner,
                                      style: context
                                          .onPrimaryTextTheme.bodyMedium);
                                },
                              ),
                            ),
                            WidgetConstant.height20,
                            Text("amount".tr,
                                style: context.primaryTextTheme.titleMedium),
                            WidgetConstant.height8,
                            ConditionalWidget(
                                enable: balance.token != null,
                                onActive: (context) => ContainerWithBorder(
                                      child: CoinAndMarketPriceView(
                                          balance: balance.amount!,
                                          showTokenImage: true),
                                    ),
                                onDeactive: (context) => ContainerWithBorder(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          OneLineTextWidget(balance.coinType,
                                              style: context.onPrimaryTextTheme
                                                  .labelLarge),
                                          Text(balance.amountStr,
                                              style: context.onPrimaryTextTheme
                                                  .bodyMedium)
                                        ]))),
                          ]),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: changedBalance!.length)
            ],
          ),
        ),
      ],
    );
  }
}
