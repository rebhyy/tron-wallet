import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/transaction/core/controller.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';

class TransactionStateBuilder extends StatefulWidget {
  const TransactionStateBuilder({super.key});

  @override
  State<TransactionStateBuilder> createState() =>
      _TransactionStateBuilderState();
}

class _TransactionStateBuilderState extends State<TransactionStateBuilder>
    with SafeState<TransactionStateBuilder> {
  late TransactionStateController controller;

  void switchAccount(ChainAccount? address) {
    if (address == null) return;
    final currentController = controller;
    currentController.setPageProgress();
    final newController = controller.cloneController(address);
    controller = newController;
    updateState();
    controller.init();
    currentController.dispose();
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    controller = context.getArgruments();
    controller.init();
  }

  @override
  void safeDispose() {
    super.safeDispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkAccountControllerView<NetworkClient, ChainAccount, Chain>(
        key: ValueKey(controller),
        title: controller.operation.value.tr,
        childBulder: (wallet, account, client, address, _) {
          return StreamPageProgress(
            controller: controller.pageKey,
            initialWidget:
                ProgressWithTextView(text: 'retrieving_network_condition'.tr),
            builder: (context) {
              return CustomScrollView(slivers: [
                SliverConstraintsBoxView(
                    padding: WidgetConstant.paddingHorizontal20,
                    sliver: MultiSliver(children: [
                      Text("account".tr, style: context.textTheme.titleMedium),
                      WidgetConstant.height8,
                      ContainerWithBorder(
                        onRemoveIcon:
                            Icon(Icons.edit, color: context.onPrimaryContainer),
                        onRemove: () {
                          context
                              .selectOrSwitchAccount(
                                  account: controller.account,
                                  showMultiSig: true)
                              .then(switchAccount);
                        },
                        child: AddressDetailsView(
                            address: controller.address,
                            color: context.onPrimaryContainer,
                            key: ValueKey(controller.address)),
                      ),
                      WidgetConstant.height20,
                      controller.onPageBuilder(context),
                    ]))
              ]);
            },
          );
        },
        addressRequired: true,
        clientRequired: true,
        account: controller.account,
        initAccount: true);
  }
}
