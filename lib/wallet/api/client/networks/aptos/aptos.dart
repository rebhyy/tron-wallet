import 'dart:async';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/provider/core/provider.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/aptos.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/constant/chain/const.dart';
import 'package:on_chain_wallet/wallet/models/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/aptos/models/types.dart';
import 'package:on_chain_wallet/wallet/models/token/token.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/aptos.dart';
import 'package:on_chain/aptos/aptos.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';

class AptosClient extends NetworkClient<AptosWalletTransaction,
    AptosAPIProvider, AptosNetworkToken, AptosAddress> {
  final AptosProvider provider;
  @override
  final WalletAptosNetwork? network;
  AptosClient({required this.provider, this.network});
  @override
  AptosHTTPService get service => provider.rpc as AptosHTTPService;

  @override
  ProviderIdentifier get serviceIdentifier => AptosProviderIdentifier(
      fullNodeIdentifier: service.provider.identifier,
      graphQlIdentifier: service.graphQlProvider.identifier);

  Future<BigInt> getAccountBalance(AptosAddress address) async {
    final r = await provider.request(
        AptosRequestExecuteViewFunctionOfaModule<BigInt>.bcs(
            entry: AptosTransactionEntryFunction(
                moduleId:
                    AptosModuleId(address: AptosAddress.one, name: "coin"),
                functionName: "balance",
                typeArgs: [
          AptosTypeTagStruct(AptosStructTag(
              address: AptosAddress.one,
              moduleName: "aptos_coin",
              name: "AptosCoin"))
        ],
                args: [
          address
        ])));
    return r.first;
  }

  Future<List<AptosAccountTokenInfo>> getAccountTokenBalances(
      {required AptosAddress address,
      List<String> assetTypes = const []}) async {
    final balances =
        await _getAccountTokenBalances(address, assetTypes: assetTypes);
    if (assetTypes.isEmpty) return balances;
    final updatedAssets = balances.map((e) => e.assetType).toList();
    assetTypes = assetTypes.where((e) => !updatedAssets.contains(e)).toList();
    for (final i in assetTypes) {
      final balance = await provider.request(
          AptosRequestGetAccountAssetResources(address: address, assetType: i));
      balances.add(
          AptosAccountTokenInfo(balance: balance, frozen: false, assetType: i));
    }
    return balances;
  }

  Future<List<AptosAccountTokenInfo>> _getAccountTokenBalances(
      AptosAddress address,
      {List<String> assetTypes = const []}) async {
    List<AptosAccountTokenInfo> updated = [];
    try {
      const limit = 1;
      int offset = 0;
      while (true) {
        final r = await provider.request(
            AptosGraphQLRequestGetCurrentFungibleAssetBalances(
                variables:
                    AptosGraphQLPaginatedVariablesParams(whereCondition: {
          "owner_address": {"_eq": address.address},
          "asset_type": {
            if (assetTypes.isNotEmpty) "_in": assetTypes,
            "_nin": updated
          }
        }, limit: limit, offset: offset)));
        for (final i in r) {
          final amount = BigintUtils.tryParse(i.amount);
          final assetType = i.assetType;
          if (amount == null || assetType == null) continue;
          if (i.ownerAddress != address.address) {
            final ownerAddress = AptosAddress(i.ownerAddress);
            if (ownerAddress != address) continue;
          }
          updated.add(AptosAccountTokenInfo(
              balance: amount, frozen: i.isFrozen, assetType: assetType));
        }
        if (r.length < limit || offset * limit > ChainConst.maxAccountTokens) {
          break;
        }
        offset++;
      }
      return updated;
    } catch (_) {
      return updated;
    }
  }

  Future<List<AptosFATokens>> getAccountFTTokens(AptosAddress address) async {
    const limit = 50;
    int offset = 0;
    List<AptosFATokens> tokens = [];
    List<String> nIn = [AptosConstants.aptosCoinAssetType];
    while (true) {
      final r = await provider
          .request(AptosGraphQLRequestGetCurrentFungibleAssetBalances(
              variables: AptosGraphQLPaginatedVariablesParams(whereCondition: {
        "owner_address": {"_eq": address.address},
        "asset_type": {"_nin": nIn}
      }, limit: limit, offset: offset)));
      final metadata =
          await provider.request(AptosGraphQLRequestGetFungibleAssetMetadata(
              variables: AptosGraphQLPaginatedVariablesParams(whereCondition: {
        "asset_type": {"_in": r.map((e) => e.assetType).toList()}
      })));

      for (final i in metadata) {
        final token = r.firstWhereOrNull((e) => e.assetType == i.assetType);
        if (token == null ||
            token.assetType == AptosConstants.aptosCoinAssetType) {
          continue;
        }
        final ftToken = AptosFATokens.create(
            balance: BigintUtils.parse(token.amount),
            token: Token(
                name: i.name,
                symbol: i.symbol,
                decimal: i.decimals,
                assetLogo: APPImage.network(i.iconUri)),
            assetType: i.assetType,
            isFreeze: token.isFrozen);
        tokens.add(ftToken);
      }
      if (r.length < limit || offset * limit > ChainConst.maxAccountTokens) {
        break;
      }
      offset++;
      nIn.addAll(r.where((e) => e.assetType != null).cast());
    }

    return tokens;
  }

  Future<BigInt> getAccountSequence(AptosAddress address) async {
    final r = await provider.request(AptosRequestGetAccount(address: address));
    return r.sequenceNumber;
  }

  Future<BigInt> getGasUnitPrice() async {
    final r = await provider.request(AptosRequestEstimateGasPrice());
    return BigInt.from(r.gasEstimate);
  }

  Future<int> getChainId() async {
    final chainId = await provider.request(AptosRequestGetLedgerInfo());
    return chainId.chainId;
  }

  Future<AptosApiUserTransaction> simulateTransaction(
      {required AptosRawTransaction rawTransaction,
      required AptosTransactionAuthenticator authenticator,
      AptosAddress? feePayer,
      List<AptosAddress>? secondarySignerAddresses}) async {
    final signedTransaction = AptosSignedTransaction(
        rawTransaction: rawTransaction, authenticator: authenticator);
    final r = await provider.request(AptosRequestSimulateTransaction(
        signedTransactionData: signedTransaction.toBcs(),
        estimateMaxGasAmount: true,
        estimateGasUnitPrice: true));
    return r.first;
  }

  Future<(String, bool)> submitTransaction(
      AptosSignedTransaction signedTx) async {
    final r = await provider.requestDynamic(
        AptosRequestSubmitTransaction(signedTransactionData: signedTx.toBcs()));
    final String? txHash = r["hash"]?.toString();
    return (txHash ?? signedTx.txHash(), txHash != null);
  }

  Future<int> getCurrenctChainId() async {
    final currentChainId = network?.coinParam.aptosChainType.id;
    if (currentChainId != null) {
      return currentChainId;
    }
    final chainId = await provider.request(AptosRequestGetLedgerInfo());
    return chainId.chainId;
  }

  Future<bool> validateGraphQl() async {
    final chainId = await provider.request(AptosGraphQLRequestChainId());
    final aptosNetwork = AptosChainType.fromValue(chainId);
    return aptosNetwork == network?.coinParam.aptosChainType;
  }

  Future<bool> validateFullNode() async {
    final chainId = await getChainId();
    final aptosNetwork = AptosChainType.fromValue(chainId);
    return aptosNetwork == network?.coinParam.aptosChainType;
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    try {
      final tx = await provider
          .requestDynamic(AptosRequestWaitForTransactionByHash(txId));
      final parsedTx =
          MethodUtils.nullOnException(() => AptosApiTransaction.fromJson(tx));
      assert(parsedTx != null, 'parsing aptos tx failed');
      if (parsedTx != null && parsedTx is AptosApiUserTransaction) {
        if (!parsedTx.success) {
          return WalletTransactionStatus.failed;
        }
      }
      return WalletTransactionStatus.block;
    } catch (e) {
      return WalletTransactionStatus.unknown;
    }
  }

  Future<void> _fetchTokenMetadata(List<AptosNetworkToken> tokens) async {
    final unknowTokens = tokens.where((e) => !e.status.isSuccess);
    if (unknowTokens.isEmpty) return;
    for (final i in unknowTokens) {
      i.setPending();
    }
    final metadata = await MethodUtils.call(() async {
      return await provider.request(AptosGraphQLRequestGetFungibleAssetMetadata(
          variables: AptosGraphQLPaginatedVariablesParams(whereCondition: {
        "asset_type": {
          "_in": unknowTokens.map((e) => e.token.assetType).toList()
        }
      })));
    });
    final result = metadata.resultOrNull ?? [];
    for (final i in unknowTokens) {
      final token =
          result.firstWhereOrNull((e) => e.assetType == i.token.assetType);
      if (token != null) {
        final ftToken = AptosFATokens.create(
            balance: i.token.balance.balance,
            token: Token(
                name: token.name,
                symbol: token.symbol,
                decimal: token.decimals,
                assetLogo: APPImage.network(token.iconUri)),
            assetType: i.token.assetType,
            isFreeze: i.token.isFreeze);
        i.setSuccess(ftToken);
        continue;
      }
      i.setError();
    }
  }

  @override
  Stream<List<AptosNetworkToken>> getAccountTokensStream(AptosAddress address) {
    final controller = StreamController<List<AptosNetworkToken>>();
    const limit = 50;
    int offset = 0;

    List<String> nIn = [AptosConstants.aptosCoinAssetType];
    Future<void> fetchTokens() async {
      while (true && !controller.isClosed) {
        List<AptosNetworkToken> tokens = [];
        final r = await MethodUtils.call(() async {
          return await provider.request(
              AptosGraphQLRequestGetCurrentFungibleAssetBalances(
                  variables:
                      AptosGraphQLPaginatedVariablesParams(whereCondition: {
            "owner_address": {"_eq": address.address},
            "asset_type": {"_nin": nIn}
          }, limit: limit, offset: offset)));
        });
        if (r.hasError) {
          controller.addError(r.exception!);
          return;
        }
        for (final i in r.result) {
          final assetType = i.assetType;
          if (assetType == null ||
              assetType == AptosConstants.aptosCoinAssetType) {
            continue;
          }
          final metadat = i.metadata;
          final token = AptosNetworkToken(
              status: metadat == null
                  ? NetworkTokenFetchingStatus.idle
                  : NetworkTokenFetchingStatus.success,
              token: AptosFATokens.create(
                  balance: BigintUtils.tryParse(i.amount) ?? BigInt.zero,
                  token: Token(
                      name: metadat?.name ?? assetType,
                      symbol: metadat?.symbol ?? assetType,
                      decimal: metadat?.decimals ?? 0),
                  assetType: assetType));

          tokens.add(token);
        }
        controller.add(tokens);
        _fetchTokenMetadata(tokens);
        if (r.result.length < limit ||
            offset * limit > ChainConst.maxAccountTokens) {
          break;
        }
        offset++;
      }
      if (!controller.isClosed) controller.close();
    }

    fetchTokens();
    return controller.stream;
  }

  @override
  Future<bool> onInit() async {
    final fullNode = await validateFullNode();
    if (fullNode) return await validateGraphQl();
    return false;
  }

  @override
  NetworkType get networkType => NetworkType.aptos;
}
