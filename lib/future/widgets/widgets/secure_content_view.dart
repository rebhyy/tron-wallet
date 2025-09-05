import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/constant/global/app.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/security/pages/secure_backup.dart';
import 'package:on_chain_wallet/wallet/models/access/wallet_access.dart';
import 'package:on_chain_wallet/wallet/models/wallet/models/backup.dart';
import 'animated/widgets/animated_switcher.dart';
import 'barcode/widgets/barcode_view.dart';
import 'conditional_widget.dart';
import 'container_with_border.dart';
import 'copy_icon_widget.dart';
import 'widget_constant.dart';

class SecureContentView extends StatefulWidget {
  const SecureContentView(
      {required this.content,
      this.showBarcode = true,
      this.isSensitive = true,
      this.backupType,
      this.showButtonTitle,
      this.contentName,
      this.credential,
      super.key});
  final String content;
  final WalletBackupTypes? backupType;
  final WalletCredentialResponseVerify? credential;
  final String? showButtonTitle;
  final String? contentName;
  final bool showBarcode;
  final bool isSensitive;

  @override
  State<SecureContentView> createState() => _SecureContentView2State();
}

class _SecureContentView2State extends State<SecureContentView>
    with SafeState<SecureContentView> {
  bool show = false;
  double opacity = 0.05;
  void showContent() {
    show = !show;
    opacity = 1;
    updateState();
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    if (!widget.isSensitive) {
      opacity = 1;
      show = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ContainerWithBorder(
          onRemove: () {},
          enableTap: false,
          onRemoveWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CopyTextIcon(
                  dataToCopy: widget.content,
                  color: context.onPrimaryContainer,
                  isSensitive: widget.isSensitive),
              ConditionalWidget(
                  enable:
                      widget.backupType != null && widget.credential != null,
                  onActive: (context) => IconButton(
                      onPressed: () {
                        context.openSliverDialog(
                            widget: (ctx) => GenerateBackupView(
                                data: widget.content,
                                credential: widget.credential!,
                                type: widget.backupType!),
                            label: "backup_mnemonic".tr);
                      },
                      icon: Icon(Icons.backup,
                          color: context.onPrimaryContainer))),
              ConditionalWidget(
                enable: widget.showBarcode,
                onActive: (context) => BarcodeImageIconView(
                    data: widget.content,
                    color: context.onPrimaryContainer,
                    isSensitive: widget.isSensitive),
              )
            ],
          ),
          child: ConstrainedBox(
            constraints: WidgetConstant.constraintsMinHeight60,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: opacity,
                  duration: APPConst.animationDuraion,
                  child: SelectableText(widget.content,
                      style: context.onPrimaryTextTheme.bodyMedium),
                ),
                Positioned.fill(
                  child: APPAnimatedSwitcher(enable: show, widgets: {
                    true: (context) => WidgetConstant.sizedBox,
                    false: (context) => FilledButton.icon(
                        onPressed: showContent,
                        icon: const Icon(Icons.remove_red_eye),
                        label:
                            Text(widget.showButtonTitle ?? "show_content".tr))
                  }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
