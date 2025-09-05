import 'dart:async';
import 'dart:js_interop';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_bridge/database/database.dart';
import 'package:on_chain_bridge/models/events/models/wallet_event.dart';
import 'package:on_chain_bridge/web/web.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:on_chain_wallet/wallet/web3/web3.dart';
import '../js_crypto_utils.dart';
import '../js_wallet/constant/constant.dart';

part 'storage.dart';
part 'web3.dart';

typedef ONDBOPENED<T> = Future<T> Function(IDatabseInterfaceJS db);

class _JSBackgroundHandler
    with JSExtensionBackgroudStorageHandler, JSExtensionBackgroudHandler {
  @override
  final IDatabseInterfaceJS storage;
  final lock = SynchronizedLock();
  _JSBackgroundHandler._(this.storage);

  Future<void> send(WalletEvent? event, int? tabId) async {
    if (event == null || tabId == null) return;
    await extension.tabs
        .sendMessage_(tabId: tabId, message: event.toJsEvent())
        .catchError((e) {
      return null;
    });
  }

  Future<void> sendAlive() async {
    final tabs = await extension.tabs.query_();
    for (final i in tabs) {
      send(
          WalletEvent(
              target: WalletEventTarget.background,
              type: WalletEventTypes.ping,
              requestId: 'sendAlive'),
          i.id);
    }
  }

  static Future<WalletEvent> sendWalletMessage(WalletEvent msg,
      {List<WalletEventTarget> allowTargets = const [
        WalletEventTarget.wallet
      ]}) async {
    bool hasListener = false;
    try {
      final Completer<WalletEvent> completer = Completer<WalletEvent>();
      bool onMessage(JSWalletEvent? message, MessageSender? sender,
          JSFunction? sendResponse) {
        final event = message?.toEvent();
        if (event == null) return false;
        if (event.type != WalletEventTypes.ping) return false;
        if (!allowTargets.contains(event.target)) {
          return false;
        }
        final result = extension.runtime.sendMessage_(message: msg);

        result.then((e) {
          completer.complete(e);
        });
        result.catchError((e) {
          completer.completeError(e);
          return null;
        });
        return true;
      }

      try {
        final r = await extension.runtime.sendMessage_(message: msg);
        return r!;
      } catch (e) {
        _onContentListener = onMessage.toJS;
        extension.runtime.onMessage.addListener(_onContentListener);
        hasListener = true;
        return await completer.future;
      }
    } finally {
      if (hasListener) {
        extension.runtime.onMessage.removeListener(_onContentListener);
      }
    }
  }

  Future<WalletEvent> openPopup(WalletEvent event) async {
    return await lock.synchronized(() async {
      final WalletEvent? windowIdResponse = await extension.runtime
          .sendMessage_(
              message: event.copyWith(target: WalletEventTarget.background))
          .then((e) => e)
          .catchError((e) => null);
      if (windowIdResponse != null) {
        return windowIdResponse;
      }
      final info = await extension.windows.getCurrent_(populate: true);
      final newLeft = IntUtils.max(0, info.left! + 100);
      final newTop = IntUtils.max(0, info.top! + 100);
      final newWidth = IntUtils.min(info.width!, 400);
      final newHeight = IntUtils.min(info.height!, 600);
      await extension.windows.create_(
          url: "${extension.runtime.getURL("index.html")}?context=popup",
          type: JSWalletConstant.extentionType,
          width: newWidth,
          height: newHeight,
          top: newTop,
          focused: true,
          left: newLeft);
      final result = await sendWalletMessage(JSWalletConstant.openExtension
          .copyWith(target: WalletEventTarget.background));

      return result;
    });
  }
}

@JS("OnBackgroundListener_")
external set _onContentListener(JSFunction? f);

@JS("OnBackgroundListener_")
external JSFunction get _onContentListener;

void main() async {
  final platform = AppNativeMethods.platform as WebPlatformInterface;
  await platform.init(APPConst.applicationId, upgradableDatebase: false);
  final handler = _JSBackgroundHandler._(platform.database);
  extension.runtime.onInstalled
      .addListener((OnInstalledDetails details) {}.toJS);
  extension.runtime.onMessage.addListener(
      (JSWalletEvent? message, MessageSender sender, JSFunction sendResponse) {
    final event = message?.toEvent();

    if (event == null ||
        event.target != WalletEventTarget.external ||
        sender.tab?.id == null) {
      return false;
    }
    switch (event.type) {
      case WalletEventTypes.tabId:
      case WalletEventTypes.background:
        handler.onContentScriptMessage(sender.tab!, event).then(
            (e) => sendResponse.callAsFunction(sendResponse, e.toJsEvent()));
        return true;
      case WalletEventTypes.openExtension:
        handler.openPopup(event).then(
            (e) => sendResponse.callAsFunction(sendResponse, e.toJsEvent()));
        return true;
      default:
        return false;
    }
  }.toJS);
  handler.sendAlive();
}
