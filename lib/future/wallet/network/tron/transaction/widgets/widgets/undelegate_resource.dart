import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/tron/transaction/operations/resource/undelegated_resource.dart';
import 'package:on_chain_wallet/future/wallet/network/tron/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/transaction.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/networks/tron/models/account_delegated_resource_info.dart';
import 'fee.dart';

class TronTransactionUnDelegateResourceContractWidget extends StatelessWidget {
  final TronTransactionUnDelegateResourceContractOperation form;
  const TronTransactionUnDelegateResourceContractWidget(
      {required this.form, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      LiveFormWidget(
        field: form.resourceInf0,
        builder: (context, field, value) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDropDownBottom<
                    TransactionResourceRequirementTronDelegatedResource>(
                  items: {
                    for (final i in form.resourceAddresses)
                      i: Text(i.address.networkAddress.toAddress())
                  },
                  hint: "resource_receiver_address".tr,
                  value: value,
                  onChanged: form.onUpdateResource,
                ),
                WidgetConstant.height20,
                APPStreamBuilder(
                  value: value!.notifier,
                  builder: (context, _) {
                    return Shimmer(
                        onActive: (enable, context) {
                          return ConditionalWidget(
                            enable: enable,
                            onActive: (context) {
                              return ConditionalWidget(
                                enable: value.status.isSuccess,
                                onDeactive: (context) => ErrorTextContainer(
                                  error: value.error,
                                  oTapError: () =>
                                      form.fetchAccountDelegateInfo(value),
                                ),
                                onActive: (context) => ListView.separated(
                                    shrinkWrap: true,
                                    physics: WidgetConstant.noScrollPhysics,
                                    itemBuilder: (context, index) {
                                      final r = value.value!.resources[index];
                                      return _ResourceDetailsView(
                                          account: form.account,
                                          selected: form.selectedResource,
                                          onChanged:
                                              form.onUpdateDelegateResource,
                                          resource: r);
                                    },
                                    separatorBuilder: (context, index) =>
                                        WidgetConstant.sizedBox,
                                    itemCount: value.value!.resources.length),
                              );
                            },
                            onDeactive: (context) => ShimmerBox(),
                          );
                        },
                        enable: !value.status.isPending);
                  },
                ),
                ConditionalWidget(
                    enable: form.selectedResource != null,
                    onActive: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetConstant.height20,
                            LiveFormWidgetAmount(
                                onUpdateAmount: (amount, max) =>
                                    form.onUpdateBalance(amount),
                                field: form.balance,
                                onUpdateAmountMax: () =>
                                    form.selectedResource?.balance.balance)
                          ],
                        ))
              ]);
        },
      ),
      WidgetConstant.height20,
      LiveFormWidgetMemo(field: form.memo, onUpdateMemo: form.onUpdateMemo),
      WidgetConstant.height20,
      TronTransactionFeeDataView(controller: form),
      TransactionStateSendTransaction(controller: form)
    ]);
  }
}

typedef _OnChangeResource = void Function(DelegateResourceDetailsCore);

class _ResourceDetailsView extends StatelessWidget {
  const _ResourceDetailsView(
      {required this.account,
      required this.resource,
      required this.onChanged,
      required this.selected});
  final DelegateResourceDetailsCore resource;
  final TronChain account;
  final _OnChangeResource onChanged;
  final DelegateResourceDetailsCore? selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContainerWithBorder(
            onRemoveWidget: APPCheckBox(
              ignoring: true,
              activePress: resource.canUnDelegated,
              value: selected == resource,
              onChanged: (p0) {},
            ),
            onRemove: () {
              onChanged(resource);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource.resource.name.camelCase,
                    style: context.onPrimaryTextTheme.labelLarge),
                CoinAndMarketPriceView(
                    balance: resource.balance,
                    style: context.onPrimaryTextTheme.titleMedium,
                    symbolColor: context.onPrimaryContainer),
                if (!resource.canUnDelegated)
                  Text(resource.expire!.toDateAndTime(),
                      style: context.onPrimaryTextTheme.bodySmall)
              ],
            ))
      ],
    );
  }
}
