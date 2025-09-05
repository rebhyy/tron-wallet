import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/select_provider.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/transaction_activity.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/bitcoin.dart';

class BitcoinAccountPageView extends StatelessWidget {
  const BitcoinAccountPageView({super.key, required this.chainAccount});
  final BitcoinChain chainAccount;
  @override
  Widget build(BuildContext context) {
    return TabBarView(physics: WidgetConstant.noScrollPhysics, children: [
      _Services(chainAccount),
      AccountTransactionActivityView<IBitcoinAddress, BitcoinWalletTransaction>(
          account: chainAccount, address: chainAccount.address)
    ]);
  }
}

class _Services extends StatelessWidget {
  const _Services(this.account);
  final BitcoinChain account;
  @override
  Widget build(BuildContext context) {
    return AccountTabbarScrollWidget(
      slivers: [
        AccountManageProviderIcon(service: account.service),
      ],
    );
  }
}
