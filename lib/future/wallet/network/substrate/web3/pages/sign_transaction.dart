import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/receipt_address_view.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/widgets/payload.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/web3/operations/sign_transaction.dart';
import 'package:on_chain_wallet/future/wallet/transaction/pages/fee.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/future/wallet/network/substrate/transaction/types/types.dart';

class Web3SubstrateSignTransactionStateView extends StatelessWidget {
  final WebSubstrateSignTransactionStateController controller;
  const Web3SubstrateSignTransactionStateView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final transactionData = controller.transactionData;
    return MultiSliver(children: [
      Text("operations".tr, style: context.textTheme.titleMedium),
      WidgetConstant.height8,
      ...List.generate(transactionData.methods.length, (i) {
        final method = transactionData.methods[i];
        return switch (method.type) {
          SubstrateKnownCallMethodsType.unknown =>
            _UnknownMethodView(method as SubstrateUnknownMethod),
          SubstrateKnownCallMethodsType.transfer =>
            _TransferMethodView(method: method as SubstrateTransferMethod),
          SubstrateKnownCallMethodsType.remark =>
            _RemarkMethodView(method as SubstrateRemarkMethod)
        };
      }),
      WidgetConstant.height20,
      SubstrateShowPayloadInfoWidget(
          payload: transactionData.extrinsicPayloadInfo),
      TransactionFeeWidget(
          fee: controller.txFee, getMaxFeeInput: () => BigInt.zero),
      Web3StateAcceptRequestView(
          controller: controller, title: "sign_transaction".tr),
    ]);
  }
}

class _RemarkMethodView extends StatelessWidget {
  final SubstrateRemarkMethod method;
  const _RemarkMethodView(this.method);

  @override
  Widget build(BuildContext context) {
    return APPExpansionListTile(
      title: Text('remark'.tr, style: context.onPrimaryTextTheme.bodyMedium),
      children: [
        ContainerWithBorder(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('data'.tr, style: context.onPrimaryTextTheme.titleMedium),
              WidgetConstant.height8,
              ContainerWithBorder(
                backgroundColor: context.onPrimaryContainer,
                child: LargeTextContainer(
                    text: method.data, color: context.primaryContainer),
              ),
              ConditionalWidget(
                  enable: method.content != null,
                  onActive: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetConstant.height20,
                            Text('content'.tr,
                                style: context.onPrimaryTextTheme.titleMedium),
                            WidgetConstant.height8,
                            ContainerWithBorder(
                              backgroundColor: context.onPrimaryContainer,
                              child: LargeTextContainer(
                                  text: method.content!,
                                  color: context.primaryContainer),
                            ),
                          ]))
            ],
          ),
        )
      ],
    );
  }
}

class _TransferMethodView extends StatelessWidget {
  final SubstrateTransferMethod method;
  const _TransferMethodView({required this.method});

  @override
  Widget build(BuildContext context) {
    return APPExpansionListTile(
      title: Text(
        'transfer'.tr,
        style: context.onPrimaryTextTheme.bodyMedium,
      ),
      children: [
        ContainerWithBorder(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('receiver_address'.tr,
                  style: context.onPrimaryTextTheme.titleMedium),
              WidgetConstant.height8,
              ContainerWithBorder(
                backgroundColor: context.onPrimaryContainer,
                onRemove: () {},
                enableTap: false,
                onRemoveIcon: CopyTextIcon(
                  dataToCopy: method.receiver.view,
                  color: context.primaryContainer,
                ),
                child: ReceiptAddressDetailsView(
                    address: method.receiver, color: context.primaryContainer),
              ),
              WidgetConstant.height20,
              Text('amount'.tr, style: context.onPrimaryTextTheme.titleMedium),
              WidgetConstant.height8,
              ContainerWithBorder(
                backgroundColor: context.onPrimaryContainer,
                child: CoinAndMarketPriceView(
                  balance: method.amount,
                  style: context.primaryTextTheme.titleMedium,
                  symbolColor: context.primaryContainer,
                  showTokenImage: true,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _UnknownMethodView extends StatelessWidget {
  final SubstrateUnknownMethod method;
  const _UnknownMethodView(this.method);

  @override
  Widget build(BuildContext context) {
    return APPExpansionListTile(
      title: Text('unknown'.tr, style: context.onPrimaryTextTheme.bodyMedium),
      children: [
        ContainerWithBorder(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('content'.tr, style: context.onPrimaryTextTheme.titleMedium),
              WidgetConstant.height8,
              ContainerWithBorder(
                backgroundColor: context.onPrimaryContainer,
                child: LargeTextContainer(
                    text: method.content, color: context.primaryContainer),
              ),
            ],
          ),
        )
      ],
    );
  }
}
