import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/constant/global/app.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/future/state_managment/extension/extension.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart'
    show ContactCore, ChainAccount;

class AddressDetailsView extends StatelessWidget {
  const AddressDetailsView(
      {required this.address, super.key, this.showBalance = true, this.color});
  final ChainAccount address;
  final bool showBalance;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConditionalWidget(
          enable: address.accountName != null,
          onActive: (context) => OneLineTextWidget(
            address.accountName!,
            style: context.textTheme.labelLarge?.copyWith(color: color),
          ),
          onDeactive: (context) {
            if (address.type == null) return WidgetConstant.sizedBox;
            return OneLineTextWidget(
              address.type!,
              style: context.textTheme.labelLarge?.copyWith(color: color),
            );
          },
        ),
        RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                style: context.textTheme.bodyMedium?.copyWith(color: color),
                children: [
                  WidgetSpan(
                      child: AddressDerivationKeyIcon(
                    address.keyIndex,
                    color: color,
                    size: context.textTheme.bodyMedium?.fontSize ??
                        APPConst.smallIconSize,
                  )),
                  TextSpan(text: " "),
                  TextSpan(text: address.address.toAddress)
                ])),
        ConditionalWidget(
            enable: showBalance,
            onActive: (context) => Column(children: [
                  WidgetConstant.height8,
                  CoinAndMarketLivePriceView(
                      liveBalance: address.address.balance,
                      style:
                          context.textTheme.titleMedium?.copyWith(color: color),
                      showTokenImage: true,
                      symbolColor: color),
                ]))
      ],
    );
  }
}

class ContactAddressView extends StatelessWidget {
  const ContactAddressView({super.key, required this.contact, this.color});
  final ContactCore contact;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OneLineTextWidget(contact.name,
            style: context.textTheme.labelLarge?.copyWith(color: color)),
        if (contact.type != null)
          Text(contact.type!.tr,
              style: context.textTheme.bodySmall?.copyWith(color: color)),
        OneLineTextWidget(contact.address,
            style: context.textTheme.bodyMedium?.copyWith(color: color)),
      ],
    );
  }
}

class AddressDrivationInfo extends StatelessWidget {
  const AddressDrivationInfo(this.keyIndex,
      {this.color, this.style, super.key});
  final AddressDerivationIndex keyIndex;
  final Color? color;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    final keyStr = keyIndex.toString().tr;

    if (keyIndex.isImportedKey) {
      return RichText(
        text: TextSpan(children: [
          WidgetSpan(
              child: AddressDerivationKeyIcon(keyIndex,
                  size: style?.fontSize ?? APPConst.smallIconSize,
                  color: color)),
          TextSpan(
              text: "imported_".tr.replaceOne(keyStr),
              style:
                  style ?? context.textTheme.bodySmall?.copyWith(color: color))
        ]),
      );
    }
    return RichText(
      text: TextSpan(children: [
        WidgetSpan(
            child: AddressDerivationKeyIcon(
          keyIndex,
          size: style?.fontSize ?? APPConst.smallIconSize,
          color: color,
        )),
        TextSpan(
            text: " ${keyIndex.toString().tr}",
            style: style ?? context.textTheme.bodySmall?.copyWith(color: color))
      ]),
    );
  }
}

class AddressDerivationKeyIcon extends StatelessWidget {
  const AddressDerivationKeyIcon(this.keyIndex,
      {this.size, this.color, super.key});
  final AddressDerivationIndex keyIndex;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    if (keyIndex.isMultiSig) {
      return ToolTipView(
          message: "multisig_address".tr,
          child: Icon(Icons.switch_account_rounded, color: color, size: size));
    }
    if (keyIndex.isImportedKey) {
      return ToolTipView(
          message: "imported_key".tr,
          child: Icon(Icons.key, color: color, size: size));
    }
    return ConditionalWidget(
      enable: keyIndex.subId == null,
      onActive: (context) => ToolTipView(
          message: "mainwallet".tr,
          child: Icon(Icons.account_balance_wallet_rounded,
              color: color, size: size)),
      onDeactive: (context) => ToolTipView(
          message: "subwallet".tr,
          child: Icon(Icons.account_balance_wallet_outlined,
              color: color, size: size)),
    );
  }
}
