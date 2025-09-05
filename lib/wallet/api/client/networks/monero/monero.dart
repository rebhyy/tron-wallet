import 'package:blockchain_utils/utils/string/string.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/impl/worker_impl.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/monero.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/constant/networks/monero.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/monero/monero.dart';
import 'package:on_chain_wallet/wallet/models/others/models/cached_object.dart';
import 'package:on_chain_wallet/wallet/models/token/network/token.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/monero.dart';

class _MoneroClientConst {
  static const int maxTxRequestPerCall = 50;
}

class MoneroClient extends NetworkClient<MoneroWalletTransaction,
    MoneroAPIProvider, BaseNetworkToken, MoneroAddress> with CryptoWokerImpl {
  MoneroClient({required this.provider, required this.network});
  final MoneroProvider provider;
  @override
  final WalletMoneroNetwork? network;
  late final CachedObject<int> _height =
      CachedObject(interval: MoneroConst.avarageBlockTime);

  CachedObject<int> get currentHeight => _height;

  String? _genesis;

  @override
  MoneroHTTPService get service => provider.rpc as MoneroHTTPService;

  Future<int> getHeight() async {
    final height = await _height.get(onFetch: () async {
      final block = await provider.request(DaemonRequestGetLastBlockHeader());
      return block.blockHeader.height;
    });
    return height;
  }

  Future<DaemonGetBlocksByHeightResponse> getBlockByRange(
      int start, int end) async {
    final List<int> heights = List.generate(end - start, (i) => start + i);
    if (heights.isEmpty) {
      heights.add(start);
    }
    final blocks =
        await provider.request(DaemonRequestGetBlocksByHeightBin(heights));
    if (blocks.blocks.length != heights.length) {
      throw ApiProviderExceptionConst.serverUnexpectedResponse;
    }
    return blocks;
  }

  Future<List<int>> getBlocksByRangeBinary(int start) async {
    final genesis = await getGenesisBlockHash();
    final blocks = await provider.requestBinary(
        DaemonRequestGetBlocksBin(
            startHeight: start,
            requestedInfo: DaemonRequestBlocksInfo.blocksOnly,
            blockIds: [genesis]),
        timeout: const Duration(minutes: 2));
    return blocks;
  }

  Future<List<DaemonBlockHeaderResponse>> getBlockHeadersRange(
      {required int start,
      required int end,
      bool validateResponse = true}) async {
    final r = await provider.request(
        DaemonRequestGetBlockHeaderByRange(startHeight: start, endHeight: end));
    if (validateResponse && r.headers.length != (end - start) + 1) {
      throw ApiProviderExceptionConst.serverUnexpectedResponse;
    }
    return r.headers;
  }

  Future<DaemonGetEstimateFeeResponse> getFeeEstimate() async {
    final result = await provider.request(const DaemonRequestGetFeeEstimate(
        MoneroNetworkConst.feeEstimateGraceBlocks));
    return result;
  }

  Future<String> getGenesisBlockHash() async {
    _genesis ??= await provider.request(DaemonRequestOnGetBlockHash(0));
    return _genesis!;
  }

  Future<List<TxResponse>> getTxesByTxIds(
      {required List<String> txIds, bool validateResponse = true}) async {
    int offset = 0;
    List<TxResponse> txes = [];
    while (offset < txIds.length) {
      int end = offset + _MoneroClientConst.maxTxRequestPerCall;
      if (end >= txIds.length) {
        end = txIds.length;
      }

      final rParams = DaemonRequestGetTransactions(txIds.sublist(offset, end),
          prune: false, decodeAsJson: false, split: false);
      final result = await provider.request(rParams);
      if (validateResponse) {
        if (rParams.txHashes.length != result.length) {
          throw ApiProviderExceptionConst.serverUnexpectedResponse;
        }
        for (int i = 0; i < rParams.txHashes.length; i++) {
          if (!StringUtils.hexEqual(rParams.txHashes[i], result[i].txHash)) {
            throw ApiProviderExceptionConst.serverUnexpectedResponse;
          }
        }
      }
      txes.addAll(result);
      offset += result.length;
    }
    assert(txes.length == txIds.length);

    return txes;
  }

  Future<MoneroTransaction> getTx(String txId) async {
    final rParams = DaemonRequestGetTransactions([txId],
        prune: false, decodeAsJson: false, split: false);
    final result = await provider.request(rParams);
    if (result.length != 1) {
      throw ApiProviderException.message("transaction_not_found");
    }
    return result[0].toTx();
  }

  Future<List<DaemonKeyImageSpentStatus>> keyImagesStatus(
      List<String> keyImages,
      {bool validateResponse = true}) async {
    int offset = 0;
    List<DaemonKeyImageSpentStatus> status = [];
    while (offset < keyImages.length) {
      int end = offset + _MoneroClientConst.maxTxRequestPerCall;
      if (end >= keyImages.length) {
        end = keyImages.length;
      }

      final rParams =
          DaemonRequestIsKeyImageSpent(keyImages.sublist(offset, end));
      final result = await provider.request(rParams);
      if (validateResponse) {
        if (rParams.keyImages.length != result.spentStatus.length) {
          throw ApiProviderExceptionConst.serverUnexpectedResponse;
        }
      }
      status.addAll(result.spentStatus);
      offset += result.spentStatus.length;
    }
    assert(status.length == keyImages.length);

    // final result =
    //     await provider.request(DaemonRequestIsKeyImageSpent(keyImages));
    // if (validateResponse && result.spentStatus.length != keyImages.length) {
    //   throw ApiProviderExceptionConst.serverUnexpectedResponse;
    // }
    return status;
  }

  Future<List<int>> getBinaryAbsoluteDistribution() async {
    final distributions = await provider.requestBinary(
        DaemonRequestGetOutputDistributionBin(
            amounts: [BigInt.zero], compress: true, cumulative: false));
    return distributions;
  }

  Future<GetOutResponse> getOuts(
      List<DaemonGetOutRequestParams> outputs) async {
    final outs = await provider
        .request(DaemonRequestGetOuts(outputs: outputs, getTxId: false));
    return outs;
  }

  Future<DaemonSendRawTxResponse> sendTx(String txHex,
      {bool doNotRelay = false, bool doSanityChecks = true}) async {
    return await provider.request(DaemonRequestSendRawTransaction(
        txAsHex: txHex,
        doNotRelay: doNotRelay,
        doSanityChecks: doSanityChecks));
  }

  Future<bool> validateNetworkGenesis() async {
    final gnesis = await getGenesisBlockHash();
    return gnesis == network?.genesisBlock;
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    final r = await provider.request(DaemonRequestGetTransactions([txId]));
    if (r.length != 1) return WalletTransactionStatus.unknown;
    final tx = r[0];
    if (tx.inPool || tx.height == null) return WalletTransactionStatus.pending;
    if (tx.doubleSpend) return WalletTransactionStatus.failed;
    return WalletTransactionStatus.block;
  }

  @override
  Future<bool> onInit() async {
    await getHeight();
    return validateNetworkGenesis();
  }

  @override
  NetworkType get networkType => NetworkType.monero;
}

class MoneroWalletClient extends NetworkClient<MoneroWalletTransaction,
    MoneroAPIProvider, BaseNetworkToken, MoneroAddress> with CryptoWokerImpl {
  final MoneroProvider provider;
  List<MoneroWalletRPCAddress>? _addresses;
  MoneroWalletClient(MoneroAPIProvider provider, this.network)
      : provider = MoneroProvider(MoneroHTTPService(provider));

  @override
  WalletMoneroNetwork? network;

  @override
  MoneroHTTPService get service => provider.rpc as MoneroHTTPService;

  Future<WalletRPCGetAccountsResponse> readMoneroWalletAccounts() async {
    return provider.request(WalletRequestGetAccounts());
  }

  Future<List<MoneroWalletRPCAddress>> readMoneroWalletAdresses() async {
    final accounts = await readMoneroWalletAccounts();
    final List<MoneroWalletRPCAddress> existsAccounts = [];
    for (final i in accounts.subaddressAccounts) {
      final addresses = await provider
          .request(WalletRequestGetAddress(accountIndex: i.accountIndex));
      existsAccounts.addAll(addresses.addresses
          .map((e) => MoneroWalletRPCAddress(
                address: e.address,
                index: MoneroAccountIndex(
                    major: i.accountIndex, minor: e.addressIndex),
              ))
          .toList());
    }
    return existsAccounts;
  }

  Future<List<MoneroAccountPendingTxes>> readMoneroWalletTxes(
      MoneroChain account) async {
    final addresses = _addresses ?? await readMoneroWalletAdresses();
    final accounts = account.addresses
        .where((e) => addresses.any((r) => e.networkAddress == r.address))
        .toList();
    if (accounts.isEmpty) return [];
    final Map<MoneroViewPrimaryAccountDetails, MoneroAccountPendingTxes>
        availableTransfers = {};
    for (final i in accounts) {
      if (availableTransfers.containsKey(i.addrDetails.viewKey)) continue;
      final allIndexes = account.relateAccountIndexes(i.addrDetails.viewKey);
      final r = await provider.request(WalletRequestIncommingTransfers(
          transferType: IncommingTransferType.available,
          accountIndex: i.addrDetails.index.major,
          subaddrIndices: allIndexes.map((e) => e.minor).toList()));
      List<MoneroAccountIndexTxes> indexes = [];
      for (final i in allIndexes) {
        final txes = r.where((e) =>
            e.subAddrIndex?.minor == i.minor &&
            e.subAddrIndex?.major == i.major);
        indexes.add(MoneroAccountIndexTxes(
            index: i, txes: txes.map((e) => e.txHash).toList()));
      }
      if (indexes.isEmpty) continue;
      availableTransfers[i.addrDetails.viewKey] =
          MoneroAccountPendingTxes.request(
              primaryAddress: i.addrDetails.viewKey,
              indexes: indexes,
              accountIndex: i.keyIndex.cast());
    }

    return availableTransfers.values.toList();
  }

  @override
  Future<bool> onInit() async {
    _addresses = await readMoneroWalletAdresses();
    return true;
  }

  @override
  NetworkType get networkType => NetworkType.monero;

  @override
  Future<WalletTransactionStatus> transactionStatus({required String txId}) {
    throw UnimplementedError();
  }
}
