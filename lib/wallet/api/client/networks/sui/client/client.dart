import 'dart:async';

import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/sui/models/types.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/sui.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/constant/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/network/params/sui.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/sui.dart';
import 'package:on_chain/sui/src/src.dart';
import 'package:on_chain_wallet/wallet/models/token/token.dart';

class SuiClient extends NetworkClient<SuiWalletTransaction, SuiAPIProvider,
    SuiNetworkToken, SuiAddress> {
  final SuiProvider provider;
  final Map<SuiAddress, SuiCachedAccountCoins> _cachedAccountCoins = {};
  @override
  final WalletSuiNetwork? network;
  SuiClient({required this.provider, this.network});
  @override
  SuiHTTPService get service => provider.rpc as SuiHTTPService;

  Future<List<SuiApiBalanceResponse>> getAcountBalances(
      SuiAddress address) async {
    return await provider.request(SuiRequestGetAllBalances(owner: address));
  }

  Future<BigInt> getGasPrice() async {
    return await provider.request(const SuiRequestGetReferenceGasPrice());
  }

  Future<SuiApiGasCostSummary> simulateGasUsed(
      SuiTransactionDataV1 transaction) async {
    final r = await provider.request(SuiRequestDryRunTransactionBlock(
        txBytes: transaction.toVariantBcsBase64()));
    if (r.effects.status.status != SuiApiExecutionStatusType.success) {
      throw ApiProviderException.message(
          r.effects.status.error ?? "transaction_simulation_failed");
    }
    return r.effects.gasUsed;
  }

  Future<SuiApiDryRunTransactionBlockResponse> simulateTransaction(
      SuiTransactionDataV1 transaction) async {
    final r = await provider.request(SuiRequestDryRunTransactionBlock(
        txBytes: transaction.toVariantBcsBase64()));
    return r;
  }

  Future<SuiExcuteTransactionData> excuteTx(
      {required SuiTransactionDataV1 tx,
      required List<SuiBaseSignature> signatures}) async {
    final excute = await provider.requestDynamic(
        SuiRequestExecuteTransactionBlock(
            txBytes: tx.toVariantBcsBase64(),
            signatures: signatures.map((e) => e.toVariantBcsBase64()).toList(),
            options: const SuiApiTransactionBlockResponseOptions(
                showEffects: true)));
    final response = MethodUtils.nullOnException(
        () => SuiApiTransactionBlockResponse.fromJson(excute));
    if (response != null) {
      return SuiExcuteTransactionData(
          digest: response.digest,
          rawTransactionData: response.rawTransaction,
          error: response.effects?.status.status !=
                  SuiApiExecutionStatusType.success
              ? response.effects?.status.error
              : null,
          effects: response.toJson());
    }
    return SuiExcuteTransactionData(
        digest: excute["digest"] ?? tx.txHash(),
        rawTransactionData: excute["rawTransaction"],
        error: excute["effects"]?["status"]?["error"],
        effects: excute);
  }

  Future<SuiExcuteTransactionData> executeWeb3Transaction({
    required String transactionBcs,
    required List<String> signatures,
    final SuiApiTransactionBlockResponseOptions? options,
    final SuiApiExecuteTransactionRequestType? type,
  }) async {
    final excute = await provider.requestDynamic(
        SuiRequestExecuteTransactionBlock(
            txBytes: transactionBcs,
            signatures: signatures,
            type: type,
            options: options ??
                const SuiApiTransactionBlockResponseOptions(
                    showEffects: true)));
    final response = MethodUtils.nullOnException(
        () => SuiApiTransactionBlockResponse.fromJson(excute));
    if (response != null) {
      return SuiExcuteTransactionData(
          digest: response.digest,
          rawTransactionData: response.rawTransaction,
          error: response.effects?.status.status !=
                  SuiApiExecutionStatusType.success
              ? response.effects?.status.error
              : null,
          effects: response.toJson());
    }
    return SuiExcuteTransactionData(
        digest: excute["digest"],
        rawTransactionData: excute["rawTransaction"],
        error: excute["effects"]?["status"]?["error"],
        effects: excute);
  }

  Future<SuiApiMoveNormalizedFunction> normalizeFunction(
      {required String package,
      required String moduleName,
      required String functionName}) async {
    final normalizedFunction = await provider.request(
        SuiRequestGetNormalizedMoveFunction(
            functionName: functionName,
            moduleName: moduleName,
            package: package));
    return normalizedFunction;
  }

  Future<List<SuiToken>> getAccountTokens(SuiAddress address,
      {bool allowSuiCoin = false}) async {
    final all =
        await provider.request(SuiRequestGetAllBalances(owner: address));
    List<SuiToken> tokens = [];
    for (final i in all) {
      if (!allowSuiCoin && i.coinType == SuiTransactionConst.suiTypeArgs) {
        continue;
      }
      final metadata = await provider
          .request(SuiRequestGetCoinMetadata(coinType: i.coinType));
      if (metadata == null) continue;
      final token = SuiToken.create(
          balance: i.totalBalance,
          token: Token(
              name: metadata.name,
              symbol: metadata.symbol,
              decimal: metadata.decimals,
              assetLogo: APPImage.network(metadata.iconUrl)),
          assetType: i.coinType);
      tokens.add(token);
    }
    return tokens;
  }

  Future<List<SuiApiCoinResponse>> getAccountSuiCoins(
      SuiAddress address) async {
    List<SuiApiCoinResponse> coins = [];
    String? cursor;
    while (true) {
      final r = await provider.request(SuiRequestGetCoins(
          coinType: SuiTransactionConst.suiTypeArgs,
          owner: address,
          pagination: SuiApiRequestPagination(cursor: cursor)));
      coins.addAll(r.data);
      cursor = r.nextCursor;
      if (!r.hasNextPage) {
        break;
      }
    }
    return coins;
  }

  Future<List<SuiApiCoinResponse>> getAccountCoins(SuiAddress address) async {
    List<SuiApiCoinResponse> coins = [];
    String? cursor;
    while (true) {
      final r = await provider.request(SuiRequestGetAllCoins(
          owner: address, pagination: SuiApiRequestPagination(cursor: cursor)));
      coins.addAll(r.data);
      cursor = r.nextCursor;
      if (!r.hasNextPage) {
        break;
      }
    }
    return coins;
  }

  Future<Map<SuiAddress, SuiApiGetDynamicFieldObjectResponse>> getObjects(
      List<SuiAddress> objectIds) async {
    final lists = ListUtils.splitList(objectIds);
    Map<SuiAddress, SuiApiGetDynamicFieldObjectResponse> response = {};
    for (final i in lists) {
      final r = await provider.request(SuiRequestMultiGetObjects(
          objectIds: i.map((e) => e.address).toList(),
          options: SuiApiObjectDataOptions(showOwner: true)));
      response.addAll({for (int j = 0; j < i.length; j++) i[j]: r[j]});
    }
    return response;
  }

  Future<List<SuiApiCoinResponse>> getCachedAccountCoins(
      SuiAddress address) async {
    final r = await getAccountCoins(address);
    _cachedAccountCoins[address] = SuiCachedAccountCoins(r);
    return _cachedAccountCoins[address]!.coinData;
  }

  Future<bool> validateNetworkIdentifier() async {
    final identifier = await provider.request(SuiRequestGetChainIdentifier());
    if (network == null) return false;
    if (network!.coinParam.suiChain != SuiChainType.devnet) {
      return identifier == network!.coinParam.identifier;
    }
    return identifier != SUIConst.mainnetIdentifier &&
        identifier != SUIConst.testnetIdentifier;
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    try {
      final identifier = await provider.requestDynamic(
          SuiRequestGetTransactionBlock(
              transactionDigest: txId,
              options:
                  SuiApiTransactionBlockResponseOptions(showEffects: true)));
      final tx = MethodUtils.nullOnException(
          () => SuiApiTransactionBlockResponse.fromJson(identifier));
      assert(tx != null, 'parsing sui tx failed');
      if (tx != null &&
          tx.effects?.status.status == SuiApiExecutionStatusType.failure) {
        return WalletTransactionStatus.failed;
      }
      return WalletTransactionStatus.block;
    } catch (_) {
      return WalletTransactionStatus.unknown;
    }
  }

  Future<void> _fetchTokenMetadata(SuiNetworkToken token) async {
    if (!token.status.allowRetry) return;
    token.setPending();
    final metadata = await MethodUtils.call(() async => await provider
        .request(SuiRequestGetCoinMetadata(coinType: token.token.assetType)));
    final result = metadata.resultOrNull;
    if (result == null) {
      token.setError();
      return;
    }
    final tokenWithMetadata = SuiToken.create(
        balance: token.token.balance.balance,
        token: Token(
            name: result.name,
            symbol: result.symbol,
            decimal: result.decimals,
            assetLogo: APPImage.network(result.iconUrl)),
        assetType: token.token.assetType);
    token.setSuccess(tokenWithMetadata);
  }

  @override
  Stream<List<SuiNetworkToken>> getAccountTokensStream(SuiAddress address) {
    final controller = StreamController<List<SuiNetworkToken>>();
    Future<void> fetchTokens() async {
      final tokens = await MethodUtils.call(() async {
        return await provider.request(SuiRequestGetAllBalances(owner: address));
      });
      try {
        if (tokens.hasError) {
          controller.addError(tokens.exception!);
          return;
        }
        List<SuiNetworkToken> suiTokens = [];
        for (final e in tokens.result) {
          if (e.coinType == SuiTransactionConst.suiTypeArgs) {
            continue;
          }
          final token = Token(name: e.coinType, symbol: e.coinType, decimal: 0);
          final suiToken = SuiNetworkToken(
              token: SuiToken.create(
                  balance: e.totalBalance,
                  token: token,
                  assetType: e.coinType));
          suiTokens.add(suiToken);
          _fetchTokenMetadata(suiToken);
        }
        controller.add(suiTokens);
      } finally {
        controller.close();
      }
    }

    fetchTokens();
    return controller.stream;
  }

  @override
  Future<bool> onInit() {
    return validateNetworkIdentifier();
  }

  @override
  NetworkType get networkType => NetworkType.sui;
}
