import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/network/network.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/web3/operations/send_transaction.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/web3/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class Web3XRPSignTransactionStateView extends StatelessWidget {
  final WebXRPSendTransactionStateController controller;
  const Web3XRPSignTransactionStateView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final transactionData = controller.transactionData;
    return MultiSliver(children: [
      Text("transaction_type".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      ContainerWithBorder(
        child: Text(transactionData.transaction.transactionType.value,
            style: context.onPrimaryTextTheme.bodyMedium),
      ),
      WidgetConstant.height20,
      Text("content".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      ContainerWithBorder(
        onRemove: () {
          context.openDialogPage(
            "transaction_content".tr,
            child: (context) => APPTextView(
                text: transactionData.content, title: "transaction_content".tr),
          );
        },
        onRemoveIcon: Icon(Icons.code, color: context.onPrimaryContainer),
        child: Text("transaction_content".tr,
            style: context.onPrimaryTextTheme.bodyMedium),
      ),
      ConditionalWidget(
          enable:
              transactionData.info?.type == SubmittableTransactionType.payment,
          onActive: (context) => _XRPWeb3TransactionInfoPayment(
              payment: transactionData.info as XRPWeb3TransactionInfoPayment)),
      ConditionalWidget(
        enable: transactionData.memos.isNotEmpty,
        onActive: (context) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          WidgetConstant.height20,
          Text("memo".tr, style: context.textTheme.titleMedium),
          WidgetConstant.height8,
          ...List.generate(
            transactionData.memos.length,
            (index) {
              final memo = transactionData.memos[index];
              return RippleMemoView(memo);
            },
          )
        ]),
      ),
      WidgetConstant.height20,
      TransactionFeeWidget(
        fee: controller.txFee,
        getMaxFeeInput: controller.maxInputFee,
        onRetryFeeEstimate: controller.estimateFee,
      ),
      Web3StateAcceptRequestView(
          controller: controller,
          title: controller.isExcute
              ? "send_transaction".tr
              : "sign_transaction".tr),
    ]);
  }
}

class _XRPWeb3TransactionInfoPayment extends StatelessWidget {
  final XRPWeb3TransactionInfoPayment payment;
  const _XRPWeb3TransactionInfoPayment({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      WidgetConstant.height20,
      ReceiptAddressView(address: payment.recipient),
      WidgetConstant.height20,
      Text("amount".tr, style: context.textTheme.titleMedium),
      ContainerWithBorder(
        child: CoinAndMarketPriceView(
          balance: payment.amount,
          style: context.onPrimaryTextTheme.titleMedium,
          symbolColor: context.onPrimaryContainer,
          showTokenImage: true,
        ),
      ),
      WidgetConstant.height20,
    ]);
  }
}
