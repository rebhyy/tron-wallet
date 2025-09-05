import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/router/page_router.dart';
import 'package:on_chain_wallet/future/state_managment/extension/extension.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/transaction/transaction.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

class RippleNFTokenView extends StatelessWidget {
  const RippleNFTokenView(
      {required this.nft,
      required this.address,
      required this.account,
      super.key});
  final RippleNFToken nft;
  final IXRPAddress address;
  final XRPChain account;
  @override
  Widget build(BuildContext context) {
    return ContainerWithBorder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("nfts_id".tr, style: context.onPrimaryTextTheme.titleMedium),
          WidgetConstant.height8,
          ContainerWithBorder(
            backgroundColor: context.onPrimaryContainer,
            child: CopyableTextWidget(
                text: nft.nftokenId, color: context.primaryContainer),
          ),
          if (nft.uri != null) ...[
            Text("uri".tr, style: context.onPrimaryTextTheme.titleMedium),
            WidgetConstant.height8,
            ContainerWithBorder(
              backgroundColor: context.onPrimaryContainer,
              child: CopyableTextWidget(
                  text: nft.uri ?? "", color: context.primaryContainer),
            ),
          ],
          Divider(color: context.onPrimaryContainer),
          AppListTile(
            title: const Text("NFTokenBurn"),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              final operation = RippleTransactionNFTokenBurnOperation(
                  address: account.address,
                  account: account,
                  walletProvider: context.wallet,
                  nftId: nft.nftokenId);
              context.to(PageRouter.transaction, argruments: operation);
            },
          ),
          AppListTile(
            title: const Text("NFTokenCreateOffer"),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              final feild = RippleTransactionNFTokenCreateOfferOperation(
                  address: account.address,
                  account: account,
                  walletProvider: context.wallet,
                  nftId: nft.nftokenId);
              context.to(PageRouter.transaction, argruments: feild);
            },
          ),
          AppListTile(
            title: const Text("NFTokenCancelOffer"),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              final feild = RippleTransactionNFTokenCancelOfferOperation(
                  address: address,
                  account: account,
                  walletProvider: context.wallet,
                  nftId: nft.nftokenId);
              context.to(PageRouter.transaction, argruments: feild);
            },
          ),
        ],
      ),
    );
  }
}
