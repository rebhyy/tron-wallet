import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:on_chain_wallet/future/wallet/controller/controller.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';

import 'login.dart';

typedef ONACCESSCREDENTIALWIDGET<RESPONSE extends WalletCredentialResponse>
    = Widget Function(RESPONSE credential);
// typedef ONACCESSCREDENTIAL = FutureOr<Object?> Function(String password);

class AccessWalletView<RESPONSE extends WalletCredentialResponse,
    REQUEST extends WalletCredential<RESPONSE>> extends StatefulWidget {
  const AccessWalletView(
      {required this.request,
      this.onWalletAccess,
      super.key,
      this.onAccsess,
      this.title,
      this.subtitle,
      this.controller,
      this.backgroundColor,
      this.appbar});
  final ONACCESSCREDENTIALWIDGET<RESPONSE>? onAccsess;
  final ONSUCCESSWALLETACCESS<RESPONSE>? onWalletAccess;
  final REQUEST request;
  final String? title;
  final Widget? subtitle;
  final ScrollController? controller;
  final AppBar? appbar;

  final Color? backgroundColor;

  @override
  State<AccessWalletView<RESPONSE, REQUEST>> createState() =>
      _AccessWalletViewState<RESPONSE, REQUEST>();
}

class _AccessWalletViewState<RESPONSE extends WalletCredentialResponse,
        REQUEST extends WalletCredential<RESPONSE>>
    extends State<AccessWalletView<RESPONSE, REQUEST>>
    with SafeState<AccessWalletView<RESPONSE, REQUEST>> {
  late final WalletProvider walletProvider;
  late final MainWallet wallet;
  late final bool platformCredential;
  ScaffoldMessengerState? key;
  StreamSubscription<dynamic>? _walletStatus;
  StreamValue<int?> lockTime = StreamValue(null);
  AppLifecycleListener? _lifeCycle;
  RESPONSE? credentials;
  static const int reminingWalletTimeAlert = kDebugMode ? 50 : 15;

  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
      controller;
  void onUpdateWalletTimer(dynamic _) {
    final time = walletProvider.wallet.reminingWalletTime;

    if (time == null || time > reminingWalletTimeAlert) {
      controller?.close();
      controller = null;
      lockTime.value = time;
    } else {
      lockTime.value = time;
      controller ??= key?.showMaterialBanner(MaterialBanner(
          actions: [
            ElevatedButton(
                onPressed: () {
                  walletProvider.wallet.onWalletIntraction();
                },
                child: Text("keep_unlock".tr))
          ],
          content: APPStreamBuilder(
            value: lockTime,
            builder: (context, value) {
              return Text(
                  "wallet_lock_timer_desc".tr.replaceOne(value.toString()));
            },
          )));
    }
  }

  void _onPause() {
    if (kDebugMode) return;
    credentials = null;
    context.backToCurrent();
    updateState();
  }

  Future<void> getCredential(RESPONSE credential) async {
    try {
      if (widget.onWalletAccess != null) {
        await widget.onWalletAccess!.call(credential);
        context.pop();
        return;
      }
      credentials = credential;
    } finally {
      updateState();
    }
  }

  void listener(WalletActionEvent status) {
    if (status.walletStatus != WStatus.unlock) {
      credentials = null;
      context.backToCurrent();
    } else {
      if (widget.onWalletAccess == null &&
          widget.request.type.isLogin &&
          walletProvider.wallet.isUnlock) {
        credentials = WalletCredentialResponseLogin.instance as RESPONSE;
      }
    }

    updateState();
  }

  StreamSubscription<WalletActionEvent>? _onWalletStatus;
  void init() {
    key = ScaffoldMessenger.maybeOf(context);
    walletProvider = context.wallet;
    wallet = walletProvider.wallet.wallet;
    platformCredential = widget.request.type.allowPlatformCredential &&
        wallet.platformCredential != null;
    _onWalletStatus = walletProvider.wallet.status.stream.listen(listener);
    listener(walletProvider.wallet.status.value);
    switch (widget.request.type) {
      case WalletCredentialType.mnemonic:
      case WalletCredentialType.importedKey:
      case WalletCredentialType.accountKey:
        _lifeCycle = AppLifecycleListener(onHide: _onPause);
        break;
      default:
    }
    _walletStatus =
        Stream.periodic(const Duration(seconds: 1)).listen(onUpdateWalletTimer);
  }

  @override
  void dispose() {
    super.dispose();
    final verificationId = credentials?.verificationId;
    if (verificationId != null) {
      walletProvider.wallet.expireCredential(verificationId);
    }
    _walletStatus?.cancel();
    _walletStatus = null;
    _onWalletStatus?.cancel();
    _onWalletStatus = null;
    _lifeCycle?.dispose();
    lockTime.dispose();
    MethodUtils.after(() async {
      controller?.close();
    });
    MethodUtils.after(() async {
      key?.clearSnackBars();
    });
  }

  PreferredSizeWidget? appBar() {
    if (widget.appbar == null && widget.title == null) {
      if (credentials == null) return AppBar(title: Text(widget.title ?? ''));
      return null;
    }
    return widget.appbar ?? AppBar(title: Text(widget.title ?? ''));
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: credentials == null ? null : widget.backgroundColor,
      appBar: appBar(),
      body: UnfocusableChild(
        child: APPAnimatedSwitcher(
          duration: APPConst.animationDuraion,
          enable: credentials != null,
          widgets: {
            true: (c) => widget.onAccsess?.call(credentials!),
            false: (c) => WalletLoginView<RESPONSE, REQUEST>(
                onWalletAccess: getCredential,
                request: widget.request,
                subtitle: widget.subtitle)
          },
        ),
      ),
    );
  }
}
