part of './background.dart';

mixin JSExtensionBackgroudHandler on JSExtensionBackgroudStorageHandler {
  final Map<String, ChaCha20Poly1305> _sharedKeys = {};

  ChaCha20Poly1305 _getOrCreateSharedKey(
      {required String clientId,
      required Web3ApplicationAuthentication application}) {
    _sharedKeys[clientId] ??= () {
      final List<int> peerKey = BytesUtils.fromHexString(clientId);
      final sharedKey = JsCryptoUtils.generateShareKey(
          privateKey: application.token.privateKey, peerKey: peerKey);
      return ChaCha20Poly1305(sharedKey);
    }();
    return _sharedKeys[clientId]!;
  }

  Web3APPAuthenticationKey generateKey() {
    final key = JsCryptoUtils.generateKey();
    return Web3APPAuthenticationKey(
        publicKey: key.publicKey, privateKey: key.privateKey);
  }

  Future<Web3ApplicationAuthentication> getPermission(
      {required Web3ClientInfo info, required MainWallet wallet}) async {
    final permission =
        await _readWeb3Permission(wallet: wallet, identifier: info.identifier);
    Web3ApplicationAuthentication? toPermission = () {
      if (permission == null) return null;
      try {
        return Web3ApplicationAuthentication.deserialize(bytes: permission);
      } catch (_) {
        return null;
      }
    }();
    if (toPermission == null) {
      final token = generateKey();
      final permission =
          info.toAuhenticated(token: token, applicationKey: info.identifier);
      await _savePermission(wallet: wallet, permission: permission);
      toPermission = permission;
    }
    return toPermission;
  }

  Future<Web3EncryptedMessage> toEncryptedMessage(
      {required Web3ApplicationAuthentication application,
      required String clientId,
      required List<int> message}) async {
    final chacha =
        _getOrCreateSharedKey(clientId: clientId, application: application);
    final nonce = QuickCrypto.generateRandom(12);
    final encryptedKey = chacha.encrypt(nonce, message);
    return Web3EncryptedMessage(message: encryptedKey, nonce: nonce);
  }

  Future<Web3GlobalRequestParams> decryptMessage(
      {required Web3ApplicationAuthentication application,
      required String clientId,
      required List<int> message}) async {
    final chacha =
        _getOrCreateSharedKey(clientId: clientId, application: application);
    final Web3EncryptedMessage msg =
        Web3EncryptedMessage.deserialize(bytes: message);
    final decrypted = chacha.decrypt(msg.nonce, msg.message);
    return Web3GlobalRequestParams.deserialize(bytes: decrypted);
  }

  // Future<WalletEvent> _getOrCreateAppAuthenticated(
  //     {required Web3ClientInfo info,
  //     required MainWallet wallet,
  //     required WalletEvent event,
  //     required int tabId}) async {
  //   Web3ApplicationAuthentication toPermission =
  //       await getPermission(info: info, wallet: wallet);

  //   final networks = await _readNetworks(wallet);
  //   final auth = await networks.createAuth(toPermission);
  //   final message = Web3ChainMessage(authenticated: auth);
  //   final encryptMessage = await toEncryptedMessage(
  //       message: message.toCbor().encode(),
  //       clientId: event.clientId,
  //       application: toPermission);
  //   return WalletEvent(
  //       clientId: event.clientId,
  //       data: encryptMessage.toCbor().encode(),
  //       requestId: event.requestId,
  //       type: WalletEventTypes.activation,
  //       target: WalletEventTarget.background,
  //       additional:
  //           "$tabId:${BytesUtils.toHexString(toPermission.token.publicKey)}");
  // }

  Web3ClientInfo buildClient(ChromeTab tab) {
    APPImage? image = APPImage.network(tab.favIconUrl);
    image ??= APPImage.faviIcon(tab.url!);

    final Web3ClientInfo? client = tab.id == null
        ? null
        : Web3ClientInfo.info(url: tab.url, faviIcon: image, name: tab.title);
    if (client == null) {
      throw Web3RequestExceptionConst.invalidHost;
    }
    return client;
  }

  Future<WalletEvent> tabInformation(
      {required ChromeTab tab,
      required WalletEvent event,
      required Web3ApplicationAuthentication application,
      required MainWallet wallet,
      required ChainsHandler chainHandler}) async {
    final auth = await chainHandler.createAuth(application);
    final message = Web3ChainMessage(authenticated: auth);
    final encryptMessage = await toEncryptedMessage(
        message: message.toCbor().encode(),
        clientId: event.clientId,
        application: application);
    return WalletEvent(
        clientId: event.clientId,
        data: encryptMessage.toCbor().encode(),
        requestId: event.requestId,
        type: WalletEventTypes.activation,
        target: WalletEventTarget.background,
        additional:
            "${tab.id!}:${BytesUtils.toHexString(application.token.publicKey)}");
  }

  Future<WalletEvent> onBackgroudMessage(
      {required WalletEvent event,
      required ChromeTab tab,
      required Web3ApplicationAuthentication application,
      required Web3ClientInfo client,
      required MainWallet wallet,
      required ChainsHandler chainHandler}) async {
    final message = (await decryptMessage(
        application: application,
        clientId: event.clientId,
        message: event.data));
    Web3APPData auth;
    switch (message.method) {
      case Web3GlobalRequestMethods.disconnect:
        final disconnect = message.cast<Web3DisconnectApplication>();
        await chainHandler
            .disconnectWeb3Chain(application, networks: [disconnect.chain]);
        auth = await chainHandler
            .createAuth(application, networks: [disconnect.chain]);
        break;
      case Web3GlobalRequestMethods.connectSilent:
        final disconnect = message.cast<Web3SilentConnectApplication>();
        final network = disconnect.chain;
        auth = await chainHandler.createAuth(application,
            networks: network == null ? null : [network]);
        break;
      default:
        throw Web3RequestExceptionConst.invalidRequest;
    }
    // final wallet = await getWallet();
    // final Web3ClientInfo client = buildClient(tab);
    // final type = NetworkType.fromTag(event.data);
    // final appAuthenticated =
    //     await getPermission(info: client, wallet: wallet);
    // await _savePermission(wallet: wallet, permission: application);
    // final networks = await _readNetworks(wallet);
    // await networks.disconnectWeb3Chain(application, networks: [type]);
    // final auth = await networks.createAuth(application, networks: [type]);
    final response = Web3GlobalResponseMessage(authenticated: auth);
    final encryptMessage = await toEncryptedMessage(
        clientId: event.clientId,
        message: response.toCbor().encode(),
        application: application);
    return WalletEvent(
        clientId: event.clientId,
        data: encryptMessage.toCbor().encode(),
        requestId: event.requestId,
        type: WalletEventTypes.message,
        target: WalletEventTarget.background);
  }

  Future<WalletEvent> onContentScriptMessage(
      ChromeTab tab, WalletEvent event) async {
    try {
      final wallet = await getWallet();
      final Web3ClientInfo client = buildClient(tab);
      Web3ApplicationAuthentication application =
          await getPermission(info: client, wallet: wallet);
      final networks = await _readNetworks(wallet);
      switch (event.type) {
        case WalletEventTypes.background:
          return onBackgroudMessage(
              event: event,
              tab: tab,
              application: application,
              client: client,
              wallet: wallet,
              chainHandler: networks);
        case WalletEventTypes.tabId:
          return tabInformation(
              tab: tab,
              event: event,
              application: application,
              wallet: wallet,
              chainHandler: networks);
        default:
          throw Web3RequestExceptionConst.internalError;
      }
    } on Web3RequestException catch (e, s) {
      Logg.error("got error $e $s");
      return WalletEvent(
          clientId: event.clientId,
          data: e.toResponseMessage().toCbor().encode(),
          requestId: event.requestId,
          type: WalletEventTypes.exception,
          target: WalletEventTarget.background);
    } catch (e, s) {
      Logg.error("got error $e $s");
      return WalletEvent(
          clientId: event.clientId,
          data: Web3RequestExceptionConst.internalError
              .toResponseMessage()
              .toCbor()
              .encode(),
          requestId: event.requestId,
          type: WalletEventTypes.exception,
          target: WalletEventTarget.background);
    }
  }
}
