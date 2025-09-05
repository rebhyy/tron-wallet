import 'package:blockchain_utils/bip/bip/conf/bip/bip_coins.dart';
import 'package:blockchain_utils/bip/bip/conf/core/coin_conf.dart';
import 'package:blockchain_utils/bip/bip/conf/core/coins.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

class SetupMoneroAddressView extends StatefulWidget {
  final AddressDerivationController controller;
  const SetupMoneroAddressView({super.key, required this.controller});
  @override
  State<SetupMoneroAddressView> createState() => _SetupMoneroAddressViewState();
}

class _SetupMoneroAddressViewState extends State<SetupMoneroAddressView>
    with SafeState {
  bool subaddress = false;

  int major = MoneroConst.minSubAddressIndex;
  int minor = MoneroConst.minSubAddressIndex;

  void setToDefault() {
    major = MoneroConst.minSubAddressIndex;
    minor = MoneroConst.minSubAddressIndex;
  }

  void onChangeMajor(int major) {
    this.major = major;
    updateState();
  }

  void onChangeMinor(int minor) {
    this.minor = minor;
    updateState();
  }

  void onChangeSubAddr(bool? _) {
    subaddress = !subaddress;
    setToDefault();
    updateState();
  }

  AddressDerivationIndex nextDerive({
    required CryptoCoins<CoinConfig> coin,
    required SeedTypes seedGeneration,
    required int? subId,
  }) {
    return (widget.controller.chain as MoneroChain).nextDerive(
        coin: coin,
        seedGeneration: seedGeneration,
        subId: subId,
        major: major,
        minor: minor);
  }

  void generateAddress() async {
    final CryptoCoins coin =
        widget.controller.network.coins.whereType<BipCoins>().first;
    final keyIndex = await widget.controller.getCoin(
        context: context,
        seedGeneration: SeedTypes.bip39,
        selectedCoins: coin,
        nextAddressDerivationBuilder: nextDerive);
    if (keyIndex == null || keyIndex.currencyCoin.conf.type != coin.conf.type) {
      return;
    }
    if (!subaddress) {
      setToDefault();
    }
    final newAccount = MoneroNewAddressParams(
        deriveIndex: keyIndex,
        major: major,
        minor: minor,
        coin: coin,
        network: widget.controller.chain
            .cast<MoneroChain>()
            .network
            .coinParam
            .network);
    widget.controller.generateAddress(newAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCheckListTile(
          contentPadding: EdgeInsets.zero,
          value: subaddress,
          title: Text("sub_address".tr, style: context.textTheme.titleMedium),
          subtitle: Text("xmr_sub_address_desc".tr),
          onChanged: onChangeSubAddr,
        ),
        APPAnimatedSize(
            isActive: subaddress,
            onActive: (c) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetConstant.height20,
                    NumberTextField(
                      label: "major_index".tr,
                      onChange: onChangeMajor,
                      max: MoneroConst.maxSubAddressIndex,
                      min: MoneroConst.minSubAddressIndex,
                      defaultValue: major,
                    ),
                    WidgetConstant.height20,
                    NumberTextField(
                      label: "minor_index".tr,
                      onChange: onChangeMinor,
                      max: MoneroConst.maxSubAddressIndex,
                      min: MoneroConst.minSubAddressIndex,
                      defaultValue: minor,
                    ),
                  ],
                ),
            onDeactive: (c) => WidgetConstant.sizedBox),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FixedElevatedButton(
              padding: WidgetConstant.paddingVertical40,
              onPressed: generateAddress,
              child: Text("generate_address".tr),
            ),
          ],
        )
      ],
    );
  }
}
