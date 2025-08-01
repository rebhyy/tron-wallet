import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/widgets/select_utxos.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/operations/send_transaction.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

class Web3BitcoinSendTransactionStateView extends StatelessWidget {
  final Web3BitcoinSendTransactionStateController form;
  const Web3BitcoinSendTransactionStateView({required this.form, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      LiveFormWidget(
        field: form.totalUtxos,
        builder: (context, field, value) {
          return ContainerWithBorder(
            onRemove: () {
              context.openDialogPage(
                  child: (context) => BitcoinTransactionSelectUtxos(form), "");
            },
            onRemoveIcon: AddOrEditIconWidget(form.hasUtxos),
            validate: form.hasUtxos,
            child: ConditionalWidget(
              onDeactive: (context) => Text("tap_to_choose_utxos".tr),
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
      Text("outputs".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      Column(
        children: List.generate(form.requestOutputs.length, (index) {
          final output = form.requestOutputs[index];
          return ContainerWithBorder(
            iconAlginment: CrossAxisAlignment.start,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConditionalWidget(
                    enable: output.address != null,
                    onDeactive: (context) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("script".tr,
                                style: context.onPrimaryTextTheme.titleMedium),
                            WidgetConstant.height8,
                            ContainerWithBorder(
                                backgroundColor: context.onPrimaryContainer,
                                child: CopyableTextWidget(
                                    text: output.script,
                                    maxLines: 3,
                                    color: context.primaryContainer)),
                            ConditionalWidget(
                                enable: output.opReturns != null,
                                onActive: (context) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          WidgetConstant.height20,
                                          Text("content".tr,
                                              style: context.onPrimaryTextTheme
                                                  .titleMedium),
                                          WidgetConstant.height8,
                                          ContainerWithBorder(
                                              backgroundColor:
                                                  context.onPrimaryContainer,
                                              child: CopyableTextWidget(
                                                  text: output.opReturns!,
                                                  maxLines: 3,
                                                  color: context
                                                      .primaryContainer)),
                                        ]))
                          ]);
                    },
                    onActive: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("recipient".tr,
                                  style:
                                      context.onPrimaryTextTheme.titleMedium),
                              WidgetConstant.height8,
                              ContainerWithBorder(
                                  backgroundColor: context.onPrimaryContainer,
                                  onRemove: output.change ? () {} : null,
                                  enableTap: false,
                                  onRemoveIcon: TappedTooltipView(
                                      tooltipWidget: ToolTipView(
                                    message:
                                        "amount_will_be_returned_back_to_account"
                                            .tr,
                                    child: Icon(Icons.change_circle_outlined,
                                        color: context.primaryContainer),
                                  )),
                                  child: ReceiptAddressDetailsView(
                                      address: output.address!,
                                      color: context.primaryContainer))
                            ])),
                ContainerWithBorder(
                  backgroundColor: context.onPrimaryContainer,
                  child: CoinAndMarketPriceView(
                    balance: output.balance,
                    style: context.primaryTextTheme.titleMedium,
                    symbolColor: context.primaryContainer,
                    showTokenImage: true,
                  ),
                )
              ],
            ),
          );
        }),
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
                          .selectOrSwitchAccount<IBitcoinAddress>(
                              account: form.account, showMultiSig: true)
                          .then((v) {
                        if (v == null) return;
                        form.onUpdateRemainingAccount(v);
                      });
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
      ConditionalWidget(
          enable: form.supportRbf,
          onActive: (context) => Column(
                children: [
                  WidgetConstant.height20,
                  LiveFormWidget(
                    field: form.rbf,
                    builder: (context, field, value) {
                      return ContainerWithBorder(
                          child: Switch(
                              value: value, onChanged: form.onUpdateRBF));
                    },
                  ),
                ],
              )),
      WidgetConstant.height20,
      TransactionFeeWidget(
          fee: form.txFee,
          getMaxFeeInput: form.getMaxFeeInput,
          onRetryFeeEstimate: form.estimateFee),
      Web3StateAcceptRequestView(
          controller: form, title: "send_transaction".tr),
    ]);
  }
}
