import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/token_details_view.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

class CosmosTransactionPickTokenView extends StatefulWidget {
  const CosmosTransactionPickTokenView(
      {required this.tokens, required this.controller, super.key});
  // final ICosmosAddress? address;
  // final WalletCosmosNetwork network;
  final List<CW20Token> tokens;
  final ScrollController controller;

  @override
  State<CosmosTransactionPickTokenView> createState() =>
      _CosmosTransactionPickTokenViewState();
}

class _CosmosTransactionPickTokenViewState
    extends State<CosmosTransactionPickTokenView>
    with SafeState<CosmosTransactionPickTokenView> {
  List<CW20Token> tokens = [];
  // CW20Token? networkToken;
  // CW20Token buildNetworkToken() {
  //   return CW20Token.create(
  //       balance: widget.address!.address.currencyBalance,
  //       token: widget.network.token,
  //       denom: widget.network.coinParam.denom);
  // }

  void buildTokens() {
    tokens = widget.tokens;
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    buildTokens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pick_token'.tr)),
      body: CustomScrollView(
        controller: widget.controller,
        slivers: [
          SliverConstraintsBoxView(
              padding: WidgetConstant.paddingHorizontal20,
              sliver: MultiSliver(children: [
                EmptyItemSliverWidgetView(
                    isEmpty: tokens.isEmpty,
                    icon: Icons.token,
                    itemBuilder: (context) => SliverList.separated(
                          itemCount: tokens.length,
                          itemBuilder: (context, index) {
                            final token = tokens[index];
                            return AccountTokenDetailsView(
                                onSelectIcon: WidgetConstant.sizedBox,
                                onSelect: () {
                                  context.pop(token);
                                },
                                token: token);
                          },
                          separatorBuilder: (context, index) =>
                              WidgetConstant.divider,
                        ))
              ])),
        ],
      ),
    );
  }
}
