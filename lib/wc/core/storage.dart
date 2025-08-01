part of 'package:on_chain_wallet/wc/wc.dart';

class WalletConnectStorage
    with DisposableMixin, BaseRepository, StreamStateController {
  @override
  String get tableId => walletKey;
  final String walletKey;
  final _lock = SynchronizedLock();
  bool _isReady = false;
  Map<String, SessionData> _activeSessions = {};
  Map<int, PublishRequest> _pendingMessage = {};

  WalletConnectStorage(this.walletKey);

  SessionData? getSession({String? topic, String? peerKey}) {
    if (topic != null) {
      return _activeSessions[topic];
    } else if (peerKey != null) {
      return _activeSessions.values
          .firstWhereNullable((e) => e.peerKey == peerKey);
    }
    return null;
  }

  Future<void> _deletePendingMessage(int id) async {
    await removeStorage(
      key: "$id",
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.web3WcMessageId,
    );
    _pendingMessage.remove(id);
  }

  Future<void> _savePendingMessage(PublishRequest message) async {
    _pendingMessage[message.correlationId] = message;
    await insertStorage(
      key: "${message.correlationId}",
      value: message,
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.web3WcMessageId,
    );
  }

  Future<void> setPendingMessage(WcInternalPublishMessageEvent event) async {
    await _lock.synchronized(() async {
      final id = event.request.correlationId;
      final status = event.status;
      if (!status.isPending) {
        await _deletePendingMessage(id);
        return;
      }
      if (_pendingMessage.containsKey(id)) return;
      await _savePendingMessage(event.request);
    });
  }

  List<PublishRequest> getPendingMessages() {
    return _pendingMessage.values.where((e) => !e.isExpired()).toList();
  }

  Future<void> setSession(SessionData session) async {
    session = session.copyWith(latestAction: DateTime.now());
    await insertStorage(
      key: session.topic,
      value: session,
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.web3WcSessionStorageId,
    );
    _activeSessions[session.topic] = session;
    notify();
  }

  Future<void> deleteSesshins() async {
    await removeStorage(
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.web3WcSessionStorageId,
    );
    _activeSessions.clear();
    notify();
  }

  Future<void> deleteSession(String topic) async {
    await removeStorage(
      key: topic,
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.web3WcSessionStorageId,
    );
    _activeSessions.remove(topic);
    notify();
  }

  List<SessionData> getActiveSessions() {
    final sessions = _activeSessions.values.where((e) => !e.isExpired).toList();
    sessions.sort((a, b) => b.latestAction.compareTo(a.latestAction));
    return sessions;
  }

  Future<Map<String, SessionData>> _initSessions() async {
    final data = await queriesStorageData(
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.web3WcSessionStorageId,
    );
    final sessions =
        data.map((e) => SessionData.deserialize(bytes: e)).toList();
    final expired = sessions.where((e) => e.isExpired).toList();
    final active = sessions.where((e) => !e.isExpired).toList();
    final removeItems = expired
        .map((e) => ITableRemoveStructA(
            storage: APPDatabaseConst.web3AuthStorage,
            storageId: APPDatabaseConst.web3WcSessionStorageId,
            tableName: tableId,
            key: e.topic))
        .toList();
    removeAllStorage(removeItems);
    return {for (final i in active) i.topic: i};
  }

  Future<Map<int, PublishRequest>> _getPendingMessage() async {
    final data = await queriesStorageData(
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.web3WcMessageId,
    );
    final sessions =
        data.map((e) => PublishRequest.deserialize(bytes: e)).toList();
    final expired = sessions.where((e) => e.isExpired()).toList();
    final active = sessions.where((e) => !e.isExpired()).toList();
    final removeItems = expired
        .map((e) => ITableRemoveStructA(
            storage: APPDatabaseConst.web3AuthStorage,
            storageId: APPDatabaseConst.web3WcMessageId,
            tableName: tableId,
            key: "${e.correlationId}"))
        .toList();
    removeAllStorage(removeItems);
    return {for (final i in active) i.correlationId: i};
  }

  Future<void> init() async {
    await _lock.synchronized(() async {
      if (_isReady) return;
      _activeSessions = await _initSessions();
      _pendingMessage = await _getPendingMessage();
      notify();
      _isReady = true;
    });
  }

  Future<void> close() async {
    await _lock.synchronized(() async {
      _activeSessions.clear();
      _pendingMessage.clear();
      _isReady = false;
      dispose();
    });
  }
}
