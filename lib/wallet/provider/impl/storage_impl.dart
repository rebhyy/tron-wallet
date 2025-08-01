part of 'package:on_chain_wallet/wallet/provider/wallet_provider.dart';

mixin WalletsStoragesManger {
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
    final read = await AppNativeMethods.platform.readDb(params);
    return read?.data;
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
    final data = await AppNativeMethods.platform.readAllDb(params);
    return data.map((e) => e.data).toList();
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
    await AppNativeMethods.platform.writeDb(params);
  }

  Future<void> _removeStorage(
      {int storage = APPDatabaseConst.hdWalletStorage,
      int storageId = APPDatabaseConst.defaultStorageId,
      String? key,
      String? keyA,
      String tableName = APPDatabaseConst.mainTableName}) async {
    final params = ITableRemoveStructA(
        storage: storage,
        storageId: storageId,
        tableName: tableName,
        key: key,
        keyA: keyA);
    await AppNativeMethods.platform.removeDb(params);
  }

  Future<HDWallets> _readWallet() async {
    final data = await _queryStorage(
        storageId: APPDatabaseConst.defaultStorageId,
        storage: APPDatabaseConst.hdWalletStorage);
    if (data == null) {
      return HDWallets.init();
    }
    return HDWallets.deserialize(bytes: data);
  }

  Future<void> _writeHdWallet(HDWallets wallet) async {
    await _insertStorage(
      storageId: APPDatabaseConst.defaultStorageId,
      storage: APPDatabaseConst.hdWalletStorage,
      value: wallet,
    );
  }

  Future<void> _removeWalletStorage(MainWallet wallet) async {
    final params = ITableDropStructA(tableName: wallet.key);

    await Future.wait([
      AppNativeMethods.platform.dropDb(params),
    ]);
  }

  Future<void> _setupWalletBackupAccounts(
      {required MainWallet wallet, required WalletRestoreV2 backup}) async {
    for (final i in backup.chains) {
      final account = i.chain;
      await account.restoreAccount(i.repositories);
      assert(account.id == wallet.key, "invalid account wallet id.");
    }
    for (final i in backup.dapps) {
      await _savePermission(wallet: wallet, permission: i);
    }
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

  Future<void> _savePermission(
      {required MainWallet wallet,
      required Web3APPAuthentication permission}) async {
    await _insertStorage(
        storage: APPDatabaseConst.web3AuthStorage,
        storageId: APPDatabaseConst.defaultStorageId,
        value: permission,
        tableName: wallet.key,
        key: permission.applicationKey);
  }

  Future<void> _removeWeb3Permission(
      {required MainWallet wallet,
      required Web3APPAuthentication permission}) async {
    await _removeStorage(
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.defaultStorageId,
      tableName: wallet.key,
      key: permission.applicationKey,
    );
  }

  Future<List<List<int>>> _readAllPermission(MainWallet wallet) async {
    return await _queriesStorage(
      storage: APPDatabaseConst.web3AuthStorage,
      storageId: APPDatabaseConst.defaultStorageId,
      tableName: wallet.key,
    );
  }
}
