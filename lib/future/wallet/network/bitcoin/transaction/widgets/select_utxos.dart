import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/address_details.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/controllers/utxos.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/types/types.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';

class BitcoinTransactionSelectUtxos extends StatelessWidget {
  final BitcoinTransactionUtxosController form;
  const BitcoinTransactionSelectUtxos(this.form, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text("choose_utxos".tr),
          actions: [
            APPStreamBuilder(
              value: form.accountUtxos,
              builder: (context, value) {
                return TextButton.icon(
                  onPressed: form.toggleAllUtxos,
                  label: Text("choose_all".tr),
                  icon: APPAnimated(
                      isActive: form.allUtxosSelected,
                      onActive: (context) => Icon(Icons.check_box),
                      onDeactive: (context) =>
                          Icon(Icons.check_box_outline_blank_outlined)),
                );
              },
            )
          ],
        ),
        SliverConstraintsBoxView(
            padding: WidgetConstant.padding20,
            sliver: MultiSliver(
              children: [
                SliverToBoxAdapter(
                    child: AlertTextContainer(
                        message:
                            "update_utxo_durning_build_transaction_desc".tr,
                        enableTap: false)),
                APPStreamBuilder(
                  value: form.accountUtxos,
                  builder: (context, addresses) {
                    return SliverList.separated(
                        separatorBuilder: (context, index) =>
                            WidgetConstant.divider,
                        itemBuilder: (context, index) {
                          final addressUtxos = addresses[index];
                          return APPStreamBuilder(
                            value: addressUtxos.notifier,
                            builder: (context, value) => Shimmer(
                                onActive: (enable, context) =>
                                    APPExpansionListTile(
                                      trailing: switch (addressUtxos.status) {
                                        BitcoinAccountUtxosStatus.pending =>
                                          WidgetConstant.sizedBox,
                                        BitcoinAccountUtxosStatus.failed =>
                                          IconButton(
                                              onPressed: () {
                                                form.getAccountsUtxos(
                                                    accountUtxos: [
                                                      addressUtxos
                                                    ]);
                                              },
                                              icon: Icon(Icons.error)),
                                        _ => null
                                      },
                                      title: Row(
                                        children: [
                                          Expanded(
                                              child: AddressDetailsView(
                                                  address:
                                                      addressUtxos.address)),
                                          ConditionalWidget(
                                            enable: addressUtxos.isSuccess,
                                            onActive: (context) =>
                                                ConditionalWidget(
                                                    enable: addressUtxos
                                                            .allSelected ||
                                                        addressUtxos
                                                                .totalSelected ==
                                                            0,
                                                    onDeactive: (context) {
                                                      return IconButton(
                                                          onPressed: () {},
                                                          icon: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Icon(Icons
                                                                  .check_box_outline_blank),
                                                              Text(addressUtxos
                                                                  .totalSelected
                                                                  .toString()),
                                                            ],
                                                          ));
                                                    },
                                                    onActive: (context) {
                                                      return APPCheckBox(
                                                          onChanged: (v) {
                                                            form.toggleAllAddressUtxos(
                                                                addressUtxos);
                                                          },
                                                          value: addressUtxos
                                                              .allSelected,
                                                          backgroundColor: context
                                                              .colors
                                                              .onPrimaryContainer,
                                                          color: context.colors
                                                              .primaryContainer);
                                                    }),
                                          )
                                        ],
                                      ),
                                      children: [
                                        ConditionalWidget(
                                            enable: addressUtxos.isSuccess,
                                            onActive: (context) {
                                              final utxoData = addressUtxos
                                                  .utxos!.utxosWithBalance;
                                              return ListView(
                                                shrinkWrap: true,
                                                physics: WidgetConstant
                                                    .noScrollPhysics,
                                                children: List.generate(
                                                    utxoData.length, (pos) {
                                                  final utxo = utxoData[pos];
                                                  return ContainerWithBorder(
                                                    onRemove: () {
                                                      form.addUtxo(
                                                          addressUtxos, utxo);
                                                    },
                                                    onRemoveWidget: APPCheckBox(
                                                      value: addressUtxos
                                                          .isSelected(utxo),
                                                      backgroundColor: context
                                                          .primaryContainer,
                                                      color: context
                                                          .onPrimaryContainer,
                                                    ),
                                                    backgroundColor: context
                                                        .onPrimaryContainer,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        OneLineTextWidget(
                                                            utxo.utxo.utxo
                                                                .txHash,
                                                            style: context
                                                                .primaryTextTheme
                                                                .bodyMedium),
                                                        CoinAndMarketPriceView(
                                                            showTokenImage:
                                                                true,
                                                            balance:
                                                                utxo.balance,
                                                            style: context
                                                                .primaryTextTheme
                                                                .titleMedium,
                                                            symbolColor: context
                                                                .primaryContainer),
                                                        if (utxo.cashToken !=
                                                            null)
                                                          Icon(
                                                            Icons.token,
                                                            color: context
                                                                .primaryContainer,
                                                          )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                            })
                                      ],
                                    ),
                                enable: !addressUtxos.isPending),
                          );
                        },
                        itemCount: addresses.length);
                  },
                ),
              ],
            ))
      ],
    );
  }
}
