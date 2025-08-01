import 'package:on_chain_bridge/database/database.dart';
import 'package:on_chain_wallet/app/core.dart';

mixin BaseRepository {
  String get tableId;

  Future<bool> insertStorage(
      {required int storage,
      int storageId = APPDatabaseConst.defaultStorageId,
      String? key,
      String? keyA,
      required CborSerializable value}) async {
    final statement = ITableInsertOrUpdateStructA(
        storage: storage,
        storageId: storageId,
        key: key,
        keyA: keyA,
        data: value.toCbor().encode(),
        tableName: tableId);
    return await AppNativeMethods.platform.writeDb(statement);
  }

  Future<ITableDataStructA?> queryStorage({
    required int storage,
    int storageId = APPDatabaseConst.defaultStorageId,
    String? key,
    String? keyA,
  }) async {
    ITableReadStructA query = ITableReadStructA(
        tableName: tableId,
        storage: storage,
        storageId: storageId,
        key: key,
        keyA: keyA);
    final data = await AppNativeMethods.platform.readDb(query);
    return data;
  }

  Future<List<int>?> queryStorageData({
    required int storage,
    int storageId = APPDatabaseConst.defaultStorageId,
    String? key,
    String? keyA,
  }) async {
    final data = await queryStorage(
        key: key, keyA: keyA, storage: storage, storageId: storageId);
    return data?.data;
  }

  Future<List<ITableDataStructA>> queriesStorage({
    required int storage,
    int? storageId = APPDatabaseConst.defaultStorageId,
    String? key,
    String? keyA,
    int? limit,
    int? offset,
    int? createdAtLt,
    int? createdAtGt,
    IDatabaseQueryOrdering ordering = IDatabaseQueryOrdering.desc,
  }) async {
    ITableReadStructA query = ITableReadStructA(
        tableName: tableId,
        storage: storage,
        storageId: storageId,
        key: key,
        keyA: keyA,
        limit: limit,
        offset: offset,
        createdAtGt: createdAtLt,
        createdAtLt: createdAtGt,
        ordering: ordering);
    final data = await AppNativeMethods.platform.readAllDb(query);
    return data;
  }

  Future<List<List<int>>> queriesStorageData({
    required int storage,
    int? storageId = APPDatabaseConst.defaultStorageId,
    String? key,
    String? keyA,
    int? limit,
    int? offset,
    int? createdAtLt,
    int? createdAtGt,
    IDatabaseQueryOrdering ordering = IDatabaseQueryOrdering.desc,
  }) async {
    final data = await queriesStorage(
        createdAtGt: createdAtGt,
        createdAtLt: createdAtLt,
        key: key,
        keyA: keyA,
        limit: limit,
        offset: offset,
        ordering: ordering,
        storage: storage,
        storageId: storageId);
    return data.map((e) => e.data).toList();
  }

  Future<bool> removeStorage(
      {required int storage,
      int? storageId = APPDatabaseConst.defaultStorageId,
      String? key,
      String? keyA}) async {
    final statement = ITableRemoveStructA(
        storage: storage,
        storageId: storageId,
        key: key,
        keyA: keyA,
        tableName: tableId);
    return await AppNativeMethods.platform.removeDb(statement);
  }

  Future<void> removeAllStorage(List<ITableRemoveStructA> items) async {
    await AppNativeMethods.platform.removeAllDb(items);
  }

  Future<void> insertAllStorage(List<ITableInsertOrUpdateStructA> items) async {
    await AppNativeMethods.platform.writeAllDb(items);
  }
}
