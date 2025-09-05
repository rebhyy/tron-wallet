import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/transaction/operations/operations.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:on_chain_wallet/future/router/page_router.dart';
import 'package:on_chain_wallet/future/state_managment/extension/extension.dart';

class RippleAccountPageView extends StatelessWidget {
  const RippleAccountPageView({required this.account, super.key});
  final XRPChain account;
  @override
  Widget build(BuildContext context) {
    return TabBarView(physics: WidgetConstant.noScrollPhysics, children: [
      _RippleServicesView(account: account),
      AccountTokensView<RippleIssueToken, IXRPAddress>(
        account: account,
        transferBuilder: (p0) {
          return RippleTransactionPaymentOperation(
              walletProvider: context.wallet,
              account: account,
              address: account.address,
              token: p0);
        },
      ),
      AccountTransactionActivityView<IXRPAddress, XRPWalletTransaction>(
          account: account, address: account.address)
    ]);
  }
}

class _RippleServicesView extends StatelessWidget {
  const _RippleServicesView({required this.account});
  final XRPChain account;
  @override
  Widget build(BuildContext context) {
    return AccountTabbarScrollWidget(
      slivers: [
        AccountManageProviderIcon(service: account.service),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppListTile(
                title: Text("trust_set".tr),
                subtitle: Text("tust_line_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionTrustSetOperation(
                    address: account.address,
                    account: account,
                    walletProvider: context.wallet,
                  );
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              WidgetConstant.divider,
              AppListTile(
                title: Text("account_set".tr),
                subtitle: Text("account_set_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionAccountSetOperation(
                      address: account.address,
                      account: account,
                      walletProvider: context.wallet);
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              WidgetConstant.divider,
              AppListTile(
                  onTap: () {
                    context.to(PageRouter.rippleAddNfts);
                  },
                  title: Text("manage_nfts".tr),
                  trailing: const Icon(Icons.arrow_forward),
                  subtitle: Text("manage_nfts_desc".tr)),
              AppListTile(
                title: const Text("NFTokenMint"),
                subtitle: Text("ripple_mint_nftoken_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionNFTokenMintOperation(
                    address: account.address,
                    account: account,
                    walletProvider: context.wallet,
                  );
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              AppListTile(
                title: const Text("NFTokenBurn"),
                subtitle: Text("ripple_nftoken_burn_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionNFTokenBurnOperation(
                    address: account.address,
                    account: account,
                    walletProvider: context.wallet,
                  );
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              AppListTile(
                title: const Text("NFTokenCreateOffer"),
                subtitle: Text("ripple_create_nftoken_offer_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation =
                      RippleTransactionNFTokenCreateOfferOperation(
                          address: account.address,
                          account: account,
                          walletProvider: context.wallet);
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              AppListTile(
                title: const Text("NFTokenCancelOffer"),
                subtitle: Text("ripple_nftoken_cancel_offer_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation =
                      RippleTransactionNFTokenCancelOfferOperation(
                          address: account.address,
                          account: account,
                          walletProvider: context.wallet);
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              AppListTile(
                title: const Text("NFTokenAcceptOffer"),
                subtitle: Text("ripple_accept_offer_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionNFTAcceptOfferOperation(
                    address: account.address,
                    account: account,
                    walletProvider: context.wallet,
                  );
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              WidgetConstant.divider,
              AppListTile(
                title: const Text("EscrowCreate"),
                subtitle: Text("ripple_escrow_create_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionEscrowCreateOperation(
                      address: account.address,
                      account: account,
                      walletProvider: context.wallet);
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              AppListTile(
                title: const Text("EscrowFinish"),
                subtitle: Text("ripple_escrow_finish_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionEscrowFinishOperation(
                    address: account.address,
                    account: account,
                    walletProvider: context.wallet,
                  );
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              AppListTile(
                title: const Text("EscrowCancel"),
                subtitle: Text("ripple_escrow_cancel_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionEscrowCancelOperation(
                      address: account.address,
                      account: account,
                      walletProvider: context.wallet);
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              WidgetConstant.divider,
              AppListTile(
                title: const Text("SetRegularKey"),
                subtitle: Text("ripple_regular_key_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionSetRegularKeyOperation(
                      address: account.address,
                      account: account,
                      walletProvider: context.wallet);
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              WidgetConstant.divider,
              AppListTile(
                title: const Text("SignerListSet"),
                subtitle: Text("ripple_set_signer_list_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  final operation = RippleTransactionSignerListSetOperation(
                      address: account.address,
                      account: account,
                      walletProvider: context.wallet);
                  context.to(PageRouter.transaction, argruments: operation);
                },
              ),
              WidgetConstant.divider,
              AppListTile(
                title: Text("ripple_key_conversion".tr),
                subtitle: Text("ripple_key_conversion_desc".tr),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  context.to(PageRouter.rippleKeyConversion);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
