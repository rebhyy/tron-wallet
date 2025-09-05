import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/constant/global/app.dart';
import 'package:on_chain_wallet/future/router/page_router.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/types.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

class AccountTokensView<TOKEN extends TokenCore, ACCOUNT extends ChainAccount>
    extends StatelessWidget {
  const AccountTokensView(
      {super.key,
      required this.account,
      this.importTokenPage,
      required this.transferBuilder});
  final String? importTokenPage;
  final APPCHAINACCOUNT<ACCOUNT> account;
  final TOKENTRANSFERBUILDER<TOKEN> transferBuilder;
  ACCOUNT get address => account.address;

  @override
  Widget build(BuildContext context) {
    return ChainStreamBuilder(
        allowNotify: [DefaultChainNotify.token],
        builder: (context, chain, lastNotify) {
          final tokens = address.tokens.whereType<TOKEN>().toList();
          return AccountTabbarScrollWidget(slivers: [
            EmptyItemSliverWidgetView(
                isEmpty: tokens.isEmpty,
                onEmpty: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.token, size: APPConst.double80),
                        WidgetConstant.height8,
                        Text("no_tokens_found".tr),
                        WidgetConstant.height20,
                        FilledButton(
                            onPressed: () {
                              context.to(PageRouter.manageTokens);
                            },
                            child: Text("monitor_my_tokens".tr))
                      ],
                    ),
                itemBuilder: (context) => SliverToBoxAdapter(
                    child: AppListTile(
                        leading: const Icon(Icons.token),
                        onTap: () {
                          context.to(PageRouter.manageTokens);
                        },
                        title: Text("manage_tokens".tr),
                        subtitle: Text("add_or_remove_tokens".tr)))),
            SliverList.builder(
                itemBuilder: (context, index) {
                  final token = tokens[index];
                  return AccountTokenDetailsView(
                    token: token,
                    onSelectWidget: WidgetConstant.sizedBox,
                    onSelect: () {
                      context.openDialogPage<TokenAction>("token_info".tr,
                          child: (ctx) => TokenDetailsModalView<TOKEN, ACCOUNT>(
                              token: token,
                              address: address,
                              account: account,
                              transferBuilder: transferBuilder));
                    },
                  );
                },
                itemCount: address.tokens.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false)
          ]);
        },
        account: account);
  }
}
