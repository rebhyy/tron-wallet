import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/receipt_address_view.dart';
import 'package:on_chain_wallet/future/wallet/network/aptos/web3/operations/send_transaction.dart';
import 'package:on_chain_wallet/future/wallet/network/aptos/web3/types/types.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';

class Web3AptosSendTransactionStateView extends StatelessWidget {
  final Web3AptosSignTransactionStateController controller;
  IWeb3AptosTransactionRawData get transactionData =>
      controller.transactionData;
  const Web3AptosSendTransactionStateView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      Text("transaction_type".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      ContainerWithBorder(
          onRemove: () {
            context.openDialogPage(
              "transaction_content".tr,
              child: (context) => APPTextView(
                  text: transactionData.transactionContent,
                  title: "transaction_content".tr),
            );
          },
          onRemoveWidget: Icon(Icons.code, color: context.onPrimaryContainer),
          child: Text(transactionData.transactionType)),
      WidgetConstant.height20,
      ConditionalWidget(
          enable: transactionData.owner != null,
          onActive: (context) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReceiptAddressView(
                      address: transactionData.owner,
                      title: "transaction_owner".tr),
                  WidgetConstant.height20,
                ]);
          }),
      ConditionalWidget(
          enable: transactionData.feePayer != null,
          onActive: (context) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReceiptAddressView(
                      address: transactionData.feePayer,
                      title: "transaction_fee_payer".tr),
                  WidgetConstant.height20,
                ]);
          }),
      ConditionalWidget(
        enable: transactionData.secondarySignerAddresses != null,
        onActive: (context) {
          final signers = transactionData.secondarySignerAddresses!;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("secondary_signer_addresses".tr,
                    style: context.textTheme.titleMedium),
                WidgetConstant.height8,
                ContainerWithBorder(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final signer = signers[index];
                        return ContainerWithBorder(
                          backgroundColor: context.onPrimaryContainer,
                          child: ReceiptAddressDetailsView(
                              address: signer, color: context.primaryContainer),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(color: context.onPrimaryContainer),
                      itemCount: signers.length),
                ),
                WidgetConstant.height20,
              ]);
        },
      ),
      Text("simulate_transaction".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      APPStreamBuilder(
        value: controller.txFee.notifier,
        builder: (context, _) {
          final fee = controller.txFee.fee;
          return Shimmer(
              onActive: (enable, context) {
                return ContainerWithBorder(
                  onRemove: enable && fee.hasError ? () {} : null,
                  enableTap: false,
                  onRemoveIcon: ConditionalWidget(
                      enable: enable && fee.hasError,
                      onActive: (context) => IconButton(
                          onPressed: controller.estimateFee,
                          icon: Icon(Icons.error,
                              color: context.onPrimaryContainer))),
                  child: ConditionalWidget(
                      onActive: (context) => ConditionalWidget(
                            enable: fee.error == null,
                            onActive: (context) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        fee.simulateInfo?.vmStatus ??
                                            "transaction_simulation_success".tr,
                                        style: context
                                            .onPrimaryTextTheme.bodyMedium),
                                  ),
                                  ConditionalWidget(
                                      enable:
                                          fee.simulateInfo?.simulateContent !=
                                              null,
                                      onActive: (context) => IconButton(
                                          onPressed: () {
                                            context.openDialogPage(
                                              "simulate_content".tr,
                                              child: (context) => APPTextView(
                                                  text: fee.simulateInfo!
                                                      .simulateContent,
                                                  title: "simulate_content".tr),
                                            );
                                          },
                                          icon: Icon(Icons.code,
                                              color:
                                                  context.onPrimaryContainer)))
                                ],
                              );
                            },
                            onDeactive: (context) => Text(fee.error?.tr ?? '',
                                style: context.onPrimaryTextTheme.bodyMedium),
                          ),
                      enable: enable,
                      onDeactive: (context) => Text(
                            "transaction_simulate_please_wait".tr,
                            style: context.onPrimaryTextTheme.bodyMedium,
                          )),
                );
              },
              enable: !controller.txFee.isPending);
        },
      ),
      WidgetConstant.height20,
      Text("transaction_fee".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      ContainerWithBorder(
          child: CoinAndMarketPriceView(
              balance: transactionData.fee,
              style: context.onPrimaryTextTheme.titleMedium,
              symbolColor: context.onPrimaryContainer)),
      Web3StateAcceptRequestView(
          controller: controller, title: "sign_transaction".tr),
    ]);
  }
}
