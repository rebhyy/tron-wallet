import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/repository/core/repository.dart';
import 'package:on_chain_wallet/crypto/impl/worker_impl.dart';

class WebViewRepository with BaseRepository, CryptoWokerImpl {
  WebViewTabStorage _tabs = WebViewTabStorage(const []);
  WebViewHistoryStorage _histories = WebViewHistoryStorage(const []);
  WebViewBookmarkStorage _bookmarks = WebViewBookmarkStorage(const []);
  List<WebViewTab> get histories => _histories.tabs;
  List<WebViewTab> get bookmarks => _bookmarks.tabs;

  bool inBokmark(WebViewTab tab) {
    return _bookmarks.inBokmark(tab);
  }

  Future<WebViewTabStorage> _getTabs() async {
    final data = await queriesStorageData(
        storage: storage, storageId: WebViewStorageType.tab.storageId);
    final tabs = data.map((e) => WebViewTab.deserialize(bytes: e)).toList();
    return WebViewTabStorage(tabs);
  }

  Future<WebViewHistoryStorage> _getHistories() async {
    final data = await queriesStorageData(
        storage: storage, storageId: WebViewStorageType.hisotry.storageId);
    final tabs = data.map((e) => WebViewTab.deserialize(bytes: e)).toList();
    return WebViewHistoryStorage(tabs);
  }

  Future<WebViewBookmarkStorage> _getBookmarks() async {
    final data = await queriesStorageData(
        storage: storage, storageId: WebViewStorageType.bookmark.storageId);
    final tabs = data.map((e) => WebViewTab.deserialize(bytes: e)).toList();
    return WebViewBookmarkStorage(tabs);
  }

  Future<void> initRepository() async {
    _tabs = await _getTabs();
    _histories = await _getHistories();
    _bookmarks = await _getBookmarks();
  }

  WebViewTab? get lastTab => _tabs.getLastObject();

  List<WebViewTab> get tabs => _tabs.tabs;
  Future<void> addOrRemoveFromBookMark(WebViewTab newTab) async {
    final add = _bookmarks.addOrRemoveFromBookMark(newTab);
    if (add) {
      await insertStorage(
          storage: storage,
          value: newTab,
          key: newTab.path ?? newTab.url,
          storageId: WebViewStorageType.bookmark.storageId);
    } else {
      await removeStorage(
          storage: storage,
          key: newTab.path ?? newTab.url,
          storageId: WebViewStorageType.bookmark.storageId);
    }
    // await _insertStorage(_bookmarks);
  }

  Future<void> saveHistory(WebViewTab tab) async {
    _histories.addNewTab(tab);
    await insertStorage(
        storage: storage,
        value: tab,
        key: tab.lastVisit.microsecondsSinceEpoch.toString(),
        storageId: WebViewStorageType.hisotry.storageId);
  }

  Future<void> updateTab(WebViewTab tab) async {
    _tabs.addOrUpdateTab(tab);
    await insertStorage(
        storage: storage,
        value: tab,
        key: tab.id,
        storageId: WebViewStorageType.tab.storageId);
  }

  Future<void> removeTab(WebViewTab tab) async {
    _tabs.removeTab(tab);
    await removeStorage(
        storage: storage,
        key: tab.id,
        storageId: WebViewStorageType.tab.storageId);
  }

  Future<void> removeHistory(WebViewTab tab) async {
    _histories.remove(tab);
    await removeStorage(
        storage: storage,
        key: tab.lastVisit.microsecondsSinceEpoch.toString(),
        storageId: WebViewStorageType.hisotry.storageId);
  }

  Future<void> removeBookmark(WebViewTab tab) async {
    _bookmarks.remove(tab);
    await removeStorage(
        storage: storage,
        key: tab.path ?? tab.url,
        storageId: WebViewStorageType.bookmark.storageId);
  }

  Future<void> clearHistory() async {
    _histories.clear();
    await removeStorage(
        storage: storage, storageId: WebViewStorageType.hisotry.storageId);
  }

  Future<void> clearBookmark() async {
    _bookmarks.clear();
    await removeStorage(
        storage: storage, storageId: WebViewStorageType.bookmark.storageId);
  }

  @override
  String get tableId => APPDatabaseConst.mainTableName;

  int get storage => APPDatabaseConst.webviewStorage;
}
