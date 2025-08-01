import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/ethereum/network/import/pages/import.dart';
import 'package:on_chain_wallet/future/wallet/network/ethereum/web3/operations/import_network.dart';
import 'package:on_chain_wallet/future/wallet/web3/pages/web3_request_page_builder.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';

class Web3EthereumImportNetworkStateView extends StatelessWidget {
  const Web3EthereumImportNetworkStateView(this.controller, {super.key});
  final Web3EthereumImportNetworkStateController controller;
  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      ImportEthereumNetworkFieldsView(form: controller.form),
      Web3StateAcceptRequestView(
          controller: controller,
          title: "import_network".tr,
          onAcceptRequest: controller.importNetwork,
          buttonKey: controller.form.buttonKey),
    ]);
  }
}
