import 'dart:async';
import 'package:flutter/material.dart';
import 'package:on_chain_bridge/models/size/models/rect.dart';
import 'package:on_chain_wallet/app/core.dart'
    show APPSetting, APPWalletSetting, StateConst, APPDatabaseConst;
import 'package:on_chain_wallet/app/utils/method/utiils.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/core/observer.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/app/models/models/currencies.dart';
import 'package:on_chain_wallet/future/tools/frame_tracker/desktop_frame_tracker.dart';
import 'package:on_chain_wallet/future/wallet/controller/tabs/tabs.dart';
import 'package:on_chain_wallet/repository/core/repository.dart';
import 'package:on_chain_wallet/wallet/models/others/models/wallet.dart';
import 'wallet/ui_wallet.dart';
import 'wallet/cross/cross.dart'
    if (dart.library.js_interop) 'wallet/cross/web.dart'
    if (dart.library.io) 'wallet/cross/io.dart';

enum APPStatusType {
  init,
  ready,
  failed;
}

class APPStatus {
  final APPStatusType status;
  final String? error;
  const APPStatus._({required this.status, this.error});
  factory APPStatus.error(String error) {
    return APPStatus._(status: APPStatusType.failed, error: error);
  }
  static const APPStatus init = APPStatus._(status: APPStatusType.init);
  static const APPStatus ready = APPStatus._(status: APPStatusType.ready);
}

class WalletProvider extends StateController
    with BaseRepository, DesktopFrameTracker, WalletProviderTabController {
  WalletProvider(
      {required APPSetting appSetting,
      required this.observer,
      required GlobalKey<NavigatorState> navigatorKey})
      : _appSetting = appSetting,
        wallet = uiWallet(navigatorKey, appSetting.config.storageVersion);

  APPStatus _status = APPStatus.init;

  APPStatus get appStatus => _status;

  ThemeData get theme => ThemeController.appTheme;
  @override
  GlobalKey<NavigatorState>? get navigatorKey => wallet.navigatorKey;
  @override
  final WalletRouteObserver observer;
  @override
  final UIWallet wallet;
  APPSetting _appSetting;
  @override
  APPSetting get appSetting => _appSetting;

  Future<void> _saveAppSetting() async {
    await insertStorage(
        storage: APPDatabaseConst.appSettingStorage,
        storageId: APPDatabaseConst.defaultStorageId,
        value: _appSetting);
  }

  void toggleBrightness() {
    ThemeController.toggleBrightness();
    notify(StateConst.main);
    notify();
    _appSetting = _appSetting.copyWith(
        appBrightness: ThemeController.appBrightness,
        appColor: ThemeController.appColorHex);
    _saveAppSetting();
  }

  void changeColor(Color color) {
    ThemeController.changeColor(color);
    notify(StateConst.main);
    _appSetting = _appSetting.copyWith(
        appBrightness: ThemeController.appBrightness,
        appColor: ThemeController.appColorHex);
    _saveAppSetting();
  }

  @override
  void updateWalletSetting(APPWalletSetting setting) {
    _appSetting = _appSetting.copyWith(walletSetting: setting);
    _saveAppSetting();
  }

  void changeCurrency(Currency? currency) {
    if (currency == null || _appSetting.currency == currency) return;
    this.currency.changeCurrency(currency);
    _appSetting = _appSetting.copyWith(currency: currency);
    _saveAppSetting();
  }

  Future<void> _initWallet() async {
    if (!appSetting.config.dbSupported) {
      _status = APPStatus.error("database_initialization_failed_desc".tr);
    } else {
      final init = await MethodUtils.call(() async {
        return await wallet.init();
      });
      if (init.hasError) {
        _status = APPStatus.error(init.localizationError);
      } else {
        _status = APPStatus.ready;
      }
    }

    notify();
  }

  @override
  Future<void> onUpdateFrame(WidgetRect rect) async {
    _appSetting = _appSetting.copyWith(size: rect);
    await _saveAppSetting();
  }

  StreamSubscription<WalletActionEvent>? _onWalletStatus;
  @override
  Future<void> onWalletEvent(WalletActionEvent event) async {
    if (!event.status.isSuccess) return;
    switch (event.walletStatus) {
      case WStatus.init:
      case WStatus.setup:
      case WStatus.lock:
        navigatorKey?.currentContext?.popToHome();
        break;
      case WStatus.readOnly:
      case WStatus.unlock:
        currency.streamPrices(wallet.coinIds());
        break;
    }
    switch (event.action) {
      case WalletActionEventType.setup:
      case WalletActionEventType.eraseWallet:
        navigatorKey?.currentContext?.popToHome();
        break;
      default:
    }
    await super.onWalletEvent(event);
    await wallet.onWalletEvent(event);
  }

  @override
  void close() {
    super.close();
    _onWalletStatus?.cancel();
    _onWalletStatus = null;
    wallet.dispose();
  }

  void onAppHover() {
    wallet.onWalletIntraction();
  }

  @override
  void ready() {
    super.ready();
    FocusManager.instance.addListener(onAppHover);
    currency.changeCurrency(appSetting.currency);
    _onWalletStatus = wallet.status.stream.listen(onWalletEvent);
    _initWallet();
  }

  @override
  String get tableId => APPDatabaseConst.mainTableName;

  @override
  bool get supportWebView => _appSetting.config.supportWebView;
}
