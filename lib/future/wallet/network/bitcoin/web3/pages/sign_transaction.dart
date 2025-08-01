import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/operations/sign_psbt_transaction.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';

class Web3BitcoinSignPSBTTransactionStateView extends StatelessWidget {
  final Web3BitcoinSignTransactionStateController controller;

  const Web3BitcoinSignPSBTTransactionStateView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final transactionData = controller.transactionData;
    return MultiSliver(children: [
      Text("total_input_amounts".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      ContainerWithBorder(
          child: CoinAndMarketPriceView(
        balance: transactionData.totalInput,
        style: context.onPrimaryTextTheme.titleMedium,
        symbolColor: context.onPrimaryContainer,
        showTokenImage: true,
      )),
      WidgetConstant.height20,
      Text("accounts".tr, style: context.textTheme.titleMedium),
      Text("inputs_from_your_accounts".tr),
      WidgetConstant.height8,
      Column(
        children: List.generate(transactionData.accountInputs.length, (index) {
          final input = transactionData.accountInputs[index];
          return ContainerWithBorder(
            iconAlginment: CrossAxisAlignment.start,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerWithBorder(
                    backgroundColor: context.onPrimaryContainer,
                    child: ReceiptAddressDetailsView(
                        address: input.address,
                        color: context.primaryContainer)),
                ContainerWithBorder(
                  backgroundColor: context.onPrimaryContainer,
                  child: CoinAndMarketPriceView(
                    balance: input.balance,
                    style: context.primaryTextTheme.titleMedium,
                    symbolColor: context.primaryContainer,
                    showTokenImage: true,
                  ),
                ),
                ErrorTextContainer(
                    enableTap: false,
                    error: input.hasChangableOutput
                        ? "bitcoin_modifiable_sighash_warning".tr
                        : null),
              ],
            ),
          );
        }),
      ),
      WidgetConstant.height20,
      Text("outputs".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      Column(
        children: List.generate(transactionData.outputs.length, (index) {
          final output = transactionData.outputs[index];
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
                      symbolColor: context.primaryContainer),
                )
              ],
            ),
          );
        }),
      ),
      WidgetConstant.height20,
      Text("transaction_fee".tr, style: context.textTheme.titleMedium),
      Text("cost_for_transaction".tr),
      WidgetConstant.height8,
      ContainerWithBorder(
        child: CoinAndMarketPriceView(
          balance: transactionData.fee,
          style: context.onPrimaryTextTheme.titleMedium,
          symbolColor: context.onPrimaryContainer,
          showTokenImage: true,
        ),
      ),
      Web3StateAcceptRequestView(
          controller: controller, title: "sign_transaction".tr),
    ]);
  }
}
