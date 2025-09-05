part of './background.dart';

mixin JSExtensionBackgroudStorageHandler {
  IDatabseInterfaceJS get storage;
  Future<T> getDatabase<T>(ONDBOPENED<T> onDbOpened) async {
    final status = await storage.openDatabase();
    if (!status.isReady) {
      throw Web3RequestExceptionConst.internalError;
    }
    final result = await onDbOpened(storage);
    return result;
  }

  Future<List<List<int>>> _queriesStorage(
      {int? storage = APPDatabaseConst.hdWalletStorage,
      int? storageId = APPDatabaseConst.defaultStorageId,
      String? key,
      String? keyA,
      String tableName = APPDatabaseConst.mainTableName}) async {
    final params = ITableReadStructA(
        storage: storage,
        storageId: storageId,
        tableName: tableName,
        key: key,
        keyA: keyA);
    return getDatabase((db) async {
      final data = await db.readAllDb(params);
      return data.map((e) => e.data).toList();
    });
  }

  Future<List<int>?> _queryStorage(
      {int storage = APPDatabaseConst.hdWalletStorage,
      int storageId = APPDatabaseConst.defaultStorageId,
      String? key,
      String? keyA,
      String tableName = APPDatabaseConst.mainTableName}) async {
    final params = ITableReadStructA(
        storage: storage,
        storageId: storageId,
        tableName: tableName,
        key: key,
        keyA: keyA);
    return getDatabase((db) async {
      final data = await db.readDb(params);
      return data?.data;
    });
  }

  Future<List<List<int>>> _readAccounts(MainWallet wallet) async {
    final data = await _queriesStorage(
        storage: null,
        tableName: wallet.key,
        storageId: APPDatabaseConst.accountStorageId);
    return data;
  }

  Future<List<int>?> _readWeb3Permission(
      {required MainWallet wallet, required String identifier}) async {
    return await _queryStorage(
        storage: APPDatabaseConst.web3AuthStorage,
        storageId: APPDatabaseConst.defaultStorageId,
        tableName: wallet.key,
        key: identifier);
  }

  Future<void> _insertStorage(
      {required CborSerializable value,
      int storage = APPDatabaseConst.hdWalletStorage,
      int storageId = APPDatabaseConst.defaultStorageId,
      String? key,
      String? keyA,
      String tableName = APPDatabaseConst.mainTableName}) async {
    final params = ITableInsertOrUpdateStructA(
        storage: storage,
        storageId: storageId,
        data: value.toCbor().encode(),
        tableName: tableName,
        key: key ?? '',
        keyA: keyA ?? '');
    await getDatabase((db) async {
      final data = await db.writeDb(params);
      return data;
    });
  }

  Future<void> _savePermission(
      {required MainWallet wallet,
      required Web3ApplicationAuthentication permission}) async {
    await _insertStorage(
        storage: APPDatabaseConst.web3AuthStorage,
        storageId: APPDatabaseConst.defaultStorageId,
        value: permission,
        tableName: wallet.key,
        key: permission.applicationId);
  }

  Future<ChainsHandler> _readNetworks(MainWallet wallet) async {
    final keys = await _readAccounts(wallet);
    final List<Chain> chains = [];
    for (final i in keys) {
      final chain = Chain.deserialize(bytes: i);
      chains.add(chain);
    }
    return ChainsHandler.setup(chains: chains, wallet: wallet);
  }

  Future<MainWallet?> _readWallet() async {
    final data = await _queryStorage(
        storageId: APPDatabaseConst.defaultStorageId,
        storage: APPDatabaseConst.hdWalletStorage,
        key: "",
        keyA: "");
    if (data == null) {
      return null;
    }
    return HDWallets.deserialize(bytes: data).getInitializeWallet();
  }

  Future<MainWallet> getWallet() async {
    final wallet = await _readWallet();
    if (wallet == null) throw Web3RequestExceptionConst.walletNotInitialized;
    return wallet;
  }
}
