part of 'package:on_chain_wallet/wallet/models/chain/chain/chain.dart';

/// for chain storage management networkid and [NetworkType.id] allowed to [100000 - 1]
class ChainStorageManager with BaseRepository {
  static const int maxAddressItemLimit = 300;

  final ChainConfig config;

  /// storage id
  final int networkId;

  /// table name
  final String id;

  /// shared storage id [NetworkType.id]
  final NetworkType networkType;
  ChainStorageManager._({
    required this.networkId,
    required this.id,
    required this.config,
    required this.networkType,
  });
  factory ChainStorageManager(
      {required WalletNetwork network,
      required String id,
      required ChainConfig config}) {
    return ChainStorageManager._(
        networkId: network.value,
        id: id,
        config: config,
        networkType: network.type);
  }
  Future<List<ITableDataStructA>> _queriesStorage(
      {required int storage,
      ChainStorageKey? storageKey,
      String? key,
      String? keyA,
      int? offset,
      int? limit,
      int? createdAtLt,
      int? createdAtGt,
      IDatabaseQueryOrdering ordering = IDatabaseQueryOrdering.desc}) async {
    return await queriesStorage(
        storageId: storageKey?.storageId,
        storage: storage,
        key: key,
        keyA: keyA,
        offset: offset,
        limit: limit,
        ordering: ordering,
        createdAtLt: createdAtLt,
        createdAtGt: createdAtGt);
  }

  Future<List<List<int>>> queriesChainStorage(
      {required ChainStorageKey storage,
      ChainAccount? address,
      String? keyA,
      int? offset,
      int? limit,
      IDatabaseQueryOrdering ordering = IDatabaseQueryOrdering.desc}) async {
    final data = await _queriesStorage(
        storage: networkId,
        key: address?.identifier,
        storageKey: storage,
        keyA: keyA,
        offset: offset,
        limit: limit,
        ordering: ordering);
    return data.map((e) => e.data).toList();
  }

  Future<List<List<int>>> queriesChainSharedStorage(
      {required ChainStorageKey storage,
      String? key,
      String? keyA,
      int? offset,
      int? limit,
      IDatabaseQueryOrdering ordering = IDatabaseQueryOrdering.desc}) async {
    final data = await _queriesStorage(
        storageKey: storage,
        key: key,
        storage: networkType.id,
        keyA: keyA,
        offset: offset,
        limit: limit,
        ordering: ordering);
    return data.map((e) => e.data).toList();
  }

  Future<List<int>?> queryChainStorage({
    required ChainStorageKey storage,
    ChainAccount? address,
    String? keyA,
  }) async {
    return await queryStorageData(
        storage: networkId,
        storageId: storage.storageId,
        key: address?.identifier,
        keyA: keyA);
  }

  Future<bool> insertChainStorage(
      {required CborSerializable value,
      required ChainStorageKey storage,
      ChainAccount? address,
      String? keyA}) async {
    final data = await insertStorage(
        storage: networkId,
        storageId: storage.storageId,
        key: address?.identifier,
        keyA: keyA,
        value: value);
    return data;
  }

  Future<bool> removeChainStorage(
      {ChainStorageKey? storage, ChainAccount? address, String? keyA}) async {
    return await removeStorage(
        storage: networkId,
        storageId: storage?.storageId,
        key: address?.identifier,
        keyA: keyA);
  }

  Future<List<int>?> queryChainSharedStorage({
    required ChainStorageKey storage,
    String? key,
    String? keyA,
  }) async {
    return queryStorageData(
      storage: networkType.id,
      storageId: storage.storageId,
      key: key,
      keyA: keyA,
    );
  }

  Future<bool> insertChainSharedStorage(
      {required CborSerializable value,
      required ChainStorageKey storage,
      String? key,
      String? keyA}) async {
    return insertStorage(
        storage: networkType.id,
        storageId: storage.storageId,
        key: key,
        keyA: keyA,
        value: value);
  }

  Future<List<WalletBackupChainRepository>> readAllRepositories() async {
    final shared = await _queriesStorage(
      storage: networkType.id,
    );
    final keys = await _queriesStorage(storage: networkId);
    List<WalletBackupChainRepository> chainRepositories = [];
    for (final i in keys) {
      final storage = config.storageKeys
          .firstWhereOrNull((e) => e.storageId == i.storageId);
      if (storage == null) {
        continue;
      }
      final repository = WalletBackupChainRepository(
          identifier: i.key,
          storageID: storage.storageId,
          value: i.data,
          networkID: networkId,
          identifier2: i.keyA,
          createdAt: i.createdAt);
      chainRepositories.add(repository);
    }
    List<WalletBackupChainRepository> sharedRepositories = [];
    for (final i in shared) {
      final storage = config.storageKeys
          .firstWhereOrNull((e) => e.storageId == i.storageId);
      assert(storage != null, "unknow storage key ");
      assert(storage?.isSharedStorage == true, "unknow storage key ");
      if (storage == null || !storage.isSharedStorage) continue;
      final repository = WalletBackupChainRepository(
          storageID: storage.storageId,
          value: i.data,
          networkID: networkId,
          identifier: i.key,
          identifier2: i.keyA,
          createdAt: i.createdAt);
      sharedRepositories.add(repository);
    }
    return [...chainRepositories, ...sharedRepositories];
  }

  Future<void> restoreChainRepositories(
      List<WalletBackupChainRepository> repositories) async {
    List<ITableInsertOrUpdateStructA> params = [];
    for (final i in repositories) {
      if (i.networkID != networkId) {
        throw WalletExceptionConst.invalidData(
            messsage: "invalid repository data.");
      }
      final storageKey = config.storageKeys
          .firstWhereOrNull((e) => e.storageId == i.storageID);
      assert(storageKey != null, "unknown storage key");
      if (storageKey == null) continue;
      final createdAt = i.createdAt;
      final param = ITableInsertOrUpdateStructA(
          data: i.value,
          storage: storageKey.isSharedStorage ? networkType.id : networkId,
          storageId: storageKey.storageId,
          key: i.identifier,
          keyA: i.identifier2,
          createdAt: createdAt == null
              ? null
              : DateTimeUtils.fromSecondsSinceEpoch(createdAt),
          tableName: tableId);
      params.add(param);
    }

    await insertAllStorage(params);
  }

  Future<void> saveAccount(Chain chain) async {
    await insertChainStorage(
        value: chain, storage: AccountChainStorageKey.account);
  }

  @override
  String get tableId => id;
}
