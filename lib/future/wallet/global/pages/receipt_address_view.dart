import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/models/others/models/receipt_address.dart';
import 'package:on_chain_wallet/future/state_managment/extension/extension.dart';

class ReceiptAddressView extends StatelessWidget {
  const ReceiptAddressView(
      {this.address,
      this.onTap,
      this.title = "recipient",
      super.key,
      this.subtitle,
      this.validate,
      this.onEditIcon,
      this.onEditWidget,
      this.enableTap = true});
  final ReceiptAddress? address;
  final DynamicVoid? onTap;
  final String? title;
  final String? subtitle;
  final bool? validate;
  final Icon? onEditIcon;
  final Widget? onEditWidget;
  // final String? errorText;
  final bool enableTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title?.tr ?? "recipient".tr,
              style: context.textTheme.titleMedium),
          if (subtitle != null) LargeTextView([subtitle!], maxLine: 2),
          WidgetConstant.height8,
        ],
        ContainerWithBorder(
          validate: validate ?? (address != null),
          onRemove: onTap,
          enableTap: enableTap,
          onRemoveWidget: onEditWidget,
          onRemoveIcon: address == null
              ? Icon(Icons.add, color: context.onPrimaryContainer)
              : onEditIcon ??
                  Icon(Icons.edit, color: context.onPrimaryContainer),
          child: APPAnimated(
            isActive: true,
            onActive: (context) => ConditionalWidget(
              key: ValueKey(address),
              enable: address != null,
              onDeactive: (context) => FullWidthWrapper(
                child: Text("tap_to_choose_address".tr,
                    style: context.onPrimaryTextTheme.bodyMedium),
              ),
              onActive: (context) => CopyableTextWidget(
                  text: address?.view ?? "",
                  widget: ReceiptAddressDetailsView(
                      address: address!, color: context.onPrimaryContainer),
                  color: context.onPrimaryContainer),
            ),
          ),
        )
      ],
    );
  }
}

class ReceiptAddressDetailsView extends StatelessWidget {
  const ReceiptAddressDetailsView(
      {required this.address, super.key, required this.color});
  final ReceiptAddress address;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConditionalWidget(
          enable: address.account?.accountName != null,
          onActive: (context) => Text(address.account!.accountName!,
              style: context.textTheme.labelLarge?.copyWith(color: color)),
          onDeactive: (context) {
            if (address.hasContact) {
              return RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style:
                          context.textTheme.bodyMedium?.copyWith(color: color),
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.contacts,
                          size: context.textTheme.bodyMedium?.fontSize ??
                              APPConst.smallIconSize,
                          color: color,
                        )),
                        TextSpan(text: " "),
                        TextSpan(
                            text: address.contact!.name,
                            style: context.textTheme.bodyMedium
                                ?.copyWith(color: color))
                      ]));
            }
            if (address.type != null) {
              return Text(address.type!.tr,
                  style: context.textTheme.labelLarge?.copyWith(color: color));
            }
            return WidgetConstant.sizedBox;
          },
        ),
        RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                style: context.textTheme.bodyMedium?.copyWith(color: color),
                children: [
                  if (address.account != null) ...[
                    WidgetSpan(
                        child: AddressDerivationKeyIcon(
                      address.account!.keyIndex,
                      color: color,
                      size: context.textTheme.bodyMedium?.fontSize ??
                          APPConst.smallIconSize,
                    )),
                    TextSpan(text: " ")
                  ],
                  TextSpan(
                      text: address.view,
                      style:
                          context.textTheme.bodyMedium?.copyWith(color: color))
                ])),
      ],
    );
  }
}
