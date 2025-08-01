import 'package:on_chain_bridge/database/database.dart';

class APPDatabaseConst {
  static const String mainTableName = "onchain";
  static const int defaultStorageId = 0;
  static const int accountStorageId = 1000;

  static const int appSettingStorage = 1;
  static const int appSwapStorage = 2;
  static const int webviewStorage = 5;
  static const int hdWalletStorage = 4;

  static const int web3AuthStorage = 100000;
  static const int web3WcSessionStorageId = 1;
  static const int web3WcMessageId = 2;

  static const ITableReadStructA appSettingQuery = ITableReadStructA(
      tableName: mainTableName,
      storage: appSettingStorage,
      storageId: defaultStorageId);
}
