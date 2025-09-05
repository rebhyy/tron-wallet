part of 'package:on_chain_wallet/wallet/provider/wallet_provider.dart';

// ignore: library_private_types_in_public_api
mixin WalletsManager on _WalletCore {
  final _lock = SynchronizedLock();
  WalletController? _wallet;
  WalletController get _controller {
    if (_wallet == null) {
      throw WalletExceptionConst.walletIsNotavailable;
    }
    return _wallet!;
  }

  StreamValue<WalletActionEvent> get status => _homePageStatus;
  final StreamValue<WalletActionEvent> _homePageStatus =
      StreamValue(WalletActionEvent.init());
  WalletActionEvent get latestEvent => _homePageStatus.value;
  WStatus get homePageStatus => _homePageStatus.value.walletStatus;
  bool get isOpen => homePageStatus.isOpen;
  bool get isLock => homePageStatus.isLock;
  bool get isUnlock => homePageStatus.isUnlock;
  bool get isReadOnly => homePageStatus.isReadOnly;
  bool get isReady => homePageStatus.isReady;
  bool get isSetup => homePageStatus.isSetup;

  HDWallets _wallets = HDWallets.init();

  void onWalletIntraction() {
    if (homePageStatus.isUnlock) {
      _timeout.start();
    }
  }

  WalletActionEvent _buildEvent(
      {required WalletActionEventType action,
      required WalletActionEventStatus status}) {
    final wStatus = _wallet?._status ?? WStatus.setup;
    return WalletActionEvent(
        walletStatus: wStatus, action: action, status: status);
  }

  void _emitStatus(WalletActionEvent event) {
    _homePageStatus.value = event;
    appLogger.debug(
        runtime: runtimeType,
        functionName: "_emitStatus",
        msg: "status: ${_homePageStatus.value.walletStatus.name}");
    if (latestEvent.status.inProgress) return;
    if (homePageStatus.isLock) {
      _wallet?.walletConnectHandler.dispose();
    }
    onWalletIntraction();
  }

  late final WalletTimeoutListener _timeout = WalletTimeoutListener(() {
    lock();
  }, () {
    if (homePageStatus.isUnlock) {
      return _wallet?._wallet.locktime.value;
    }
    return null;
  });

  Future<void> _initWallet(
      {bool useIsolate = true, String? initialPassword}) async {
    if (!homePageStatus.isSetup) {
      return;
    }
    try {
      crypto.init(useIsolate);
      _wallets = await _readWallet();
      await _initPage();
      if (initialPassword != null) {
        await _controller._login(password: initialPassword);
      }
    } catch (e, s) {
      Logg.error("here $e $s");
      rethrow;
    }
  }

  Future<void> _updateWallet(MainWallet wallet) async {
    await _wallets.updateWallet(wallet);
    await _writeHdWallet(_wallets);
  }

  Future<MethodResult<T>> _walletAction<T>(
    Future<T> Function() t, {
    Duration? delay,
  }) async {
    onWalletIntraction();
    return await MethodUtils.call(() async {
      return t();
    }, delay: delay);
  }

  Future<MethodResult<T>> _callSynchronized<T>(Future<T> Function() t,
      {bool Function()? conditionStatus,
      bool Function()? event,
      required WalletActionEventType Function() action,
      Duration? delay = APPConst.animationDuraion,
      LockId lockId = LockId.one}) async {
    return await _lock.synchronized(() async {
      final request = action();
      final event =
          _buildEvent(action: request, status: WalletActionEventStatus.pending);
      _emitStatus(event);
      MethodResult<T>? result;
      try {
        result = await _walletAction(() async {
          if (!(event.actionIsAllow() && (conditionStatus?.call() ?? true))) {
            throw WalletExceptionConst.incorrectStatus;
          }
          return await t();
        }, delay: delay);
        return result;
      } finally {
        final status = (result?.hasError ?? true)
            ? WalletActionEventStatus.failed
            : WalletActionEventStatus.success;
        final event = _buildEvent(action: request, status: status);
        _emitStatus(event);
      }
    }, lockId: lockId);
  }

  Future<void> _initPage(
      {MainWallet? slectedWallet, WalletRestoreV2? backup}) async {
    final currentController = _wallet;
    if (_wallets.hasWallet) {
      final wallet =
          await _wallets.getInitializeWallet(key: slectedWallet?.key);
      final controller =
          await WalletController._setup(this as WalletCore, wallet, backup);
      _wallet = controller;
    } else {
      _wallet = null;
    }
    currentController?._dispose();
  }

  Future<void> _setup(
      {required MainWallet hdWallet,
      required String password,
      required WalletUpdateInfosData walletInfos,
      WalletRestoreV2? backup}) async {
    if (!PasswordUtils.canUseAsPassword(password)) {
      throw WalletExceptionConst.passwordTooWeak;
    }
    final updatedWallet =
        hdWallet.updateSettings(update: walletInfos, network: 0);
    await crypto.cryptoIsolateRequest(
        CryptoRequestGenerateMasterKey.fromStorage(
            storageData: updatedWallet.data,
            key: password,
            checksum: updatedWallet.checkSumBytes,
            memoryKey: QuickCrypto.generateRandom()));
    await _wallets.setupNewWallet(updatedWallet);
    await _removeWalletStorage(updatedWallet);
    try {
      await _initPage(slectedWallet: updatedWallet, backup: backup);
    } catch (e) {
      await _wallets.removeWallet(updatedWallet);
      rethrow;
    }
    await _writeHdWallet(_wallets);
  }

  Future<bool> _switchWallet(MainWallet switchWallet) async {
    if (switchWallet.name == _controller._wallet.name) return false;
    await _initPage(slectedWallet: switchWallet);
    await _writeHdWallet(_wallets);
    return true;
  }

  Future<void> _eraseWallet(WalletCredentialResponseVerify credential) async {
    final controller = _controller;
    controller._getCachedCredPassword(credential);
    await _wallets.removeWallet(controller._wallet);
    await _removeWalletStorage(controller._wallet);
    await _initPage();
    await _writeHdWallet(_wallets);
  }

  Future<void> lock() async {
    await _callSynchronized(() async {
      _controller._logout();
    }, delay: null, action: () => WalletActionEventType.lock);
  }
}
