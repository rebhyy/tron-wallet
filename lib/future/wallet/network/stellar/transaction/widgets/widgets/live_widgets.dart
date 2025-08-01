import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/constant/global/app.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/global.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/types.dart';
import 'package:on_chain_wallet/future/wallet/network/stellar/transaction/types/operations.dart';
import 'package:on_chain_wallet/future/wallet/network/stellar/transaction/widgets/widgets/extensions.dart';
import 'package:on_chain_wallet/future/wallet/network/stellar/transaction/widgets/widgets/pick_asset.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:on_chain_wallet/future/wallet/transaction/pages/live_form_widget.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:on_chain_wallet/future/wallet/network/stellar/transaction/types/types.dart';

typedef ONSELECTSTELLARASSET = void Function(StellarPickedIssueAsset asset);
typedef ONSELECTSTELLARASSETPICKED = Widget Function(
    BuildContext context,
    LiveFormField<StellarPickedIssueAsset?, StellarPickedIssueAsset> field,
    StellarPickedIssueAsset value);

class LiveFormPickStellarAssetWidget<T extends Object?, E extends Object>
    extends StatelessWidget {
  final LiveFormField<StellarPickedIssueAsset?, StellarPickedIssueAsset> field;
  final StellarChain account;
  final bool allowCreateAsset;
  final StellarAccountResponse accountInfo;
  final ONSELECTSTELLARASSET onSelectAsset;
  final ONSELECTSTELLARASSETPICKED? onAssetPicked;
  final bool allowNativeAssets;

  final bool showBalance;
  const LiveFormPickStellarAssetWidget(
      {required this.field,
      required this.onSelectAsset,
      required this.account,
      required this.accountInfo,
      this.showBalance = true,
      this.allowNativeAssets = true,
      this.onAssetPicked,
      this.allowCreateAsset = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LiveFormWidget(
        field: field,
        builder: (context, field, value) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerWithBorder(
                  onRemoveIcon: AddOrEditIconWidget(value != null),
                  validate: field.hasValue,
                  child: value == null
                      ? Text("tap_to_select_or_create_asset".tr,
                          style: context.onPrimaryTextTheme.bodyMedium)
                      : AccountTokenDetailsWidget(
                          token: value.token,
                          color: context.onPrimaryContainer,
                          balance: showBalance ? value.tokenBalance : null,
                          radius: APPConst.circleRadius25),
                  onRemove: () {
                    context
                        .openDialogPage<StellarPickedIssueAsset>('',
                            child: (context) => StellarPickAssetView(
                                accountInfo: accountInfo,
                                chain: account,
                                allowNativeAssets: allowNativeAssets,
                                allowCreate: allowCreateAsset))
                        .then((v) {
                      if (v == null) return;
                      onSelectAsset(v);
                    });
                  },
                ),
                APPAnimated(
                    isActive: true,
                    onActive: (context) => ConditionalWidget(
                        key: ValueKey(value),
                        enable: value != null && onAssetPicked != null,
                        onActive: (context) {
                          return FullWidthWrapper(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetConstant.height20,
                                  onAssetPicked!(context, field, value!)
                                ]),
                          );
                        }))
              ]);
        });
  }
}

typedef ONTAPSTELLARADDRESSACTIVITYERROR = void Function(
    TransactionResourceRequirementStellarAccountActivity);

class LiveFormWidgetStellarAddressWithActivity<NETWORKADDRESS>
    extends StatelessWidget {
  final bool visibleOnNull;
  final LiveFormField<TransactionResourceRequirementStellarAccountActivity?,
      TransactionResourceRequirementStellarAccountActivity> field;
  final APPCHAINNETWORK<NETWORKADDRESS> account;
  final ONUPDATEADDRESS<NETWORKADDRESS>? onUpdateAddress;
  final ONTAPSTELLARADDRESSACTIVITYERROR? onTapError;
  const LiveFormWidgetStellarAddressWithActivity(
      {this.onUpdateAddress,
      required this.field,
      required this.account,
      this.visibleOnNull = true,
      this.onTapError,
      super.key});

  @override
  Widget build(BuildContext context) {
    final subtitle = field.subtitle;
    return APPStreamBuilder(
      value: field.live,
      builder: (context, value) {
        if (!visibleOnNull && value == null) return WidgetConstant.sizedBox;
        final address = value;
        bool hasAddress = address != null;
        final onUpdateAddress = this.onUpdateAddress;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(field.title, style: context.textTheme.titleMedium),
          if (subtitle != null) Text(subtitle),
          WidgetConstant.height8,
          ConditionalWidget(
            enable: value != null,
            onDeactive: (context) => ContainerWithBorder(
              validate: false,
              onRemove: onUpdateAddress == null
                  ? null
                  : () {
                      context
                          .selectAccount<NETWORKADDRESS>(account: account)
                          .then(
                        (value) {
                          final address = value?.firstOrNull;
                          onUpdateAddress(address);
                        },
                      );
                    },
              onRemoveIcon: AddOrEditIconWidget(hasAddress),
              child: Text("tap_to_choose_address".tr,
                  style: context.onPrimaryTextTheme.bodyMedium),
            ),
            onActive: (context) => APPStreamBuilder(
              value: value!.notifier,
              builder: (context, _) {
                return Shimmer(
                    onActive: (enable, context) {
                      return ContainerWithBorder(
                        onTapError: onTapError == null
                            ? null
                            : () {
                                onTapError?.call(value);
                              },
                        onRemove: onUpdateAddress == null
                            ? null
                            : () {
                                context
                                    .selectAccount<NETWORKADDRESS>(
                                        account: account)
                                    .then(
                                  (value) {
                                    final address = value?.firstOrNull;
                                    onUpdateAddress(address);
                                  },
                                );
                              },
                        onRemoveWidget: Row(
                          children: [
                            IconButton(
                                onPressed: onUpdateAddress == null
                                    ? null
                                    : () {
                                        context
                                            .selectAccount<NETWORKADDRESS>(
                                                account: account)
                                            .then(
                                          (value) {
                                            final address = value?.firstOrNull;
                                            onUpdateAddress(address);
                                          },
                                        );
                                      },
                                icon: AddOrEditIconWidget(hasAddress)),
                            IconButton(
                                tooltip: value.status.message?.tr,
                                onPressed: () {
                                  onTapError?.call(value);
                                },
                                icon: StatusIconWidget(
                                  status: value.status.toProgressStatus,
                                  size: APPConst.iconSize,
                                  onProgressIcon: Icon(Icons.account_circle),
                                  onSuccessIcon: value.status.isInactive
                                      ? Icon(Icons.no_accounts_rounded,
                                          color: context.onPrimaryContainer)
                                      : Icon(Icons.account_circle,
                                          color: context.onPrimaryContainer),
                                ))
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: ReceiptAddressDetailsView(
                              address: address!.address,
                              color: context.onPrimaryContainer,
                            )),
                            CopyTextIcon(
                                dataToCopy: address.address.view,
                                color: context.onPrimaryContainer,
                                isSensitive: false)
                          ],
                        ),
                      );
                    },
                    enable: !value.status.isPending);
              },
            ),
          ),
        ]);
      },
    );
  }
}
