import 'dart:async';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/worker.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/ethereum/client/ethereum.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/tron/tron.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/tron.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/networks.dart';
import 'package:on_chain_wallet/wallet/models/token/token.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/tron.dart';
import 'package:on_chain/on_chain.dart';

class TronClient extends NetworkClient<TronWalletTransaction, TronAPIProvider,
    TronNetworkToken, TronAddress> with CryptoWokerImpl, HttpImpl {
  TronClient(
      {required this.provider,
      required this.solidityProvider,
      required this.network});

  final TronProvider provider;
  final EthereumClient solidityProvider;
  @override
  final WalletTronNetwork network;
  @override
  NetworkServiceProtocol<TronAPIProvider> get service =>
      provider.rpc as NetworkServiceProtocol<TronAPIProvider>;

  Future<TronAccountInfo?> getAccount(TronAddress account) async {
    final tronAccount =
        await provider.request(TronRequestGetAccountInfo(address: account));
    return tronAccount;
  }

  Future<TronAccountData?> getAccountInfo(TronAddress address) async {
    final account = await getAccount(address);
    if (account == null) return TronAccountData();
    final resource = await getAccountResource(address);
    return TronAccountData(accountInfo: account, resource: resource);
  }

  Future<BigInt> getTrc10Balance(String tokenID, TronAddress account) async {
    final tronAccount =
        await provider.request(TronRequestGetAccountInfo(address: account));
    final tokenBalance =
        tronAccount?.assetV2.firstWhereOrNull((e) => e.key == tokenID);
    return tokenBalance?.value ?? BigInt.zero;
  }

  Future<TronAccountResourceInfo> getAccountResource(
      TronAddress account) async {
    return await provider
        .request(TronRequestGetAccountResourceInfo(address: account));
  }

  Future<TronChainParameters> getChainParameters() async {
    return await provider.request(TronRequestGetChainParameters());
  }

  Future<TronBlock> getNowBlock() async {
    final tronBlock = await provider.request(TronRequestGetNowBlock());
    return tronBlock;
  }

  Future<List<TronIssueTRC10Token>> getIssueAssetList() async {
    final tokens = await provider.request(TronRequestListOfIssueTRC10());
    return tokens;
  }

  Future<TronTRC10Token?> getIssueById(String id,
      {TronAddress? account}) async {
    final issue = await provider.request(TronRequestIssueById(id));
    if (issue == null) {
      return null;
    }
    BigInt balance = BigInt.zero;
    if (account != null) {
      balance = await getTrc10Balance(issue.id, account);
    }
    return TronTRC10Token.create(
        balance: balance,
        token: Token(
            name: issue.name,
            symbol: issue.abbr ?? issue.name,
            decimal: issue.precision ?? 0),
        tokenID: issue.id);
  }

  Future<TronBroadcastHexResponse> sendTransaction(String digest) async {
    final result =
        await provider.request(TronRequestBroadcastHex(transaction: digest));
    return result;
  }

  Future<int> estimateContractEnergy({
    required TronAddress ownerAddress,
    required TronAddress contractAddress,
    AbiFunctionFragment? fragment,
    required String data,
    BigInt? callValue,
    BigInt? callTokenValue,
    BigInt? tokenID,
  }) async {
    final energyRequired = await provider.request(
        TronRequestTriggerConstantContract(
            ownerAddress: ownerAddress,
            contractAddress: contractAddress,
            data: data,
            fragment: fragment,
            callValue: callValue,
            callTokenValue: callTokenValue,
            tokenId: tokenID));
    if (!energyRequired.isSuccess) {
      throw ApiProviderException.message(
          energyRequired.error ?? 'fee_estimate_failed');
    }
    return energyRequired.energyUsed!;
  }

  Future<int> estimateCreateContractEnergy({
    required TronAddress ownerAddress,
    required String byteCode,
    BigInt? callValue,
    BigInt? callTokenValue,
    BigInt? tokenID,
  }) async {
    final energyRequired = await provider.request(
        TronRequestTriggerConstantContract(
            ownerAddress: ownerAddress,
            data: byteCode,
            callValue: callValue,
            callTokenValue: callTokenValue,
            tokenId: tokenID));
    if (!energyRequired.isSuccess) {
      throw ApiProviderException.message(
          energyRequired.error ?? 'fee_estimate_failed');
    }
    return energyRequired.energyUsed!;
  }

  Future<(MaxDelegatedResourceAmount, MaxDelegatedResourceAmount)>
      getMaxDelegatedEnergyAndBandwidth(TronAddress address) async {
    final bandwidth = await provider.request(
        TronRequestGetCanDelegatedMaxSizeV2(
            ownerAddress: address,
            type: ResourceCode.bandWidth.value,
            network: network));
    final energy = await provider.request(TronRequestGetCanDelegatedMaxSizeV2(
        ownerAddress: address,
        type: ResourceCode.energy.value,
        network: network));
    return (energy, bandwidth);
  }

  Future<List<String>> getDelegatedResourceAddresses(
      ITronAddress address) async {
    final delegatedAddresses = await provider.request(
        TronRequestGetAccountDelegatedResourceAddresses(
            value: address.networkAddress));
    return delegatedAddresses;
  }

  Future<DelegatedAccountResourceInfo> getDelegatedResourceInfo(
      TronAddress from, TronAddress to) async {
    final details = await provider.request(
        TronRequestGetDelegatedResourceV2Details(
            fromAddress: from, toAddress: to, network: network));
    return details;
  }

  Future<bool> checkGenesis() async {
    final block = await provider.request(TronRequestGetBlockByNum(num: 0));
    return block["blockID"] == network.genesisBlock;
  }

  Future<bool> checkSolidityChainId() async {
    final chainId = await solidityProvider.getChainId();
    return chainId.toInt() == network.tronNetworkType.genesisBlockNumber;
  }

  Future<TronScanAccountTokens> getTronScanAccountTokens(TronAddress address,
      {int start = 0}) async {
    final tokens = await httpGet<Map<String, dynamic>>(
        TronClientUtils.buildTronScanUrl(
            address: address, chain: network.tronNetworkType, start: start),
        headers: HttpCallerUtils.applicationJsonContentType,
        responseType: HTTPResponseType.map);
    return TronScanAccountTokens.fromJson(tokens.result);
  }

  Future<void> _fetchTrc10TokenMetadatas(List<TronNetworkToken> tokens) async {
    final trc10Tokens = tokens
        .where((e) => e.token.tronTokenType.isTrc10 && e.status.allowRetry)
        .toList();
    if (trc10Tokens.isEmpty) return;

    for (final i in trc10Tokens) {
      i.setPending();
    }
    final issueList = await MethodUtils.call(() async {
      return await getIssueAssetList();
    });

    final issueTokens = issueList.resultOrNull ?? [];
    for (final i in trc10Tokens) {
      final token = issueTokens
          .firstWhereNullable((element) => element.id == i.token.issuer);
      assert(token != null, "unknow trc10 asset.");
      if (token == null) {
        i.setError();
        continue;
      }
      i.updaetTokenMetadata(Token(
          name: token.name,
          symbol: token.abbr ?? token.name,
          // assetLogo: APPImage.network(token.url),
          decimal: token.precision ?? 0));
    }
  }

  @override
  Stream<List<TronNetworkToken>> getAccountTokensStream(TronAddress address) {
    final controller = StreamController<List<TronNetworkToken>>();
    void add(List<TronNetworkToken> tokens) {
      if (!controller.isClosed) {
        controller.add(tokens);
      }
    }

    void error(Object err) {
      if (!controller.isClosed) controller.addError(err);
    }

    void close() {
      if (!controller.isClosed) controller.close();
    }

    Future<void> fetchTokens() async {
      final result =
          await MethodUtils.call(() async => await getAccount(address));

      if (result.hasError) {
        error(result.exception!);
        close();
        return;
      }

      final account = result.result;
      List<TronNetworkToken> trc10Tokens = [];
      if (account != null && account.assetV2.isNotEmpty) {
        trc10Tokens = account.assetV2
            .map((e) => TronTRC10Token.create(
                balance: e.value,
                token: Token(name: e.key, symbol: e.key, decimal: 0),
                tokenID: e.key))
            .map((e) => TronNetworkToken(token: e))
            .toList();
        add(trc10Tokens);
        _fetchTrc10TokenMetadatas(trc10Tokens);
      }

      int max = TronClientUtils.tronScanMaxTokenLimit;
      int offset = 0;
      while (max == TronClientUtils.tronScanMaxTokenLimit) {
        final tronscanAssets = await MethodUtils.call(() async {
          return await getTronScanAccountTokens(address,
              start: offset * TronClientUtils.tronScanMaxTokenLimit);
        });
        if (tronscanAssets.hasError) {
          error(tronscanAssets.exception!);
          close();
          return;
        }
        final trc10Metadatas = tronscanAssets.result.tokens
            .where((e) => e.tokenType == TronTokenTypes.trc10.name)
            .toList();
        for (final i in trc10Tokens) {
          final metadata = trc10Metadatas
              .firstWhereNullable((e) => e.tokenId == i.token.identifier);
          if (metadata != null) {
            i.updaetTokenMetadata(i.token.token
                .copyWith(assetLogo: APPImage.network(metadata.tokenLogo)));
          }
        }
        final tc20Assets = tronscanAssets.result.tokens
            .where((e) => e.tokenType == TronTokenTypes.trc20.name)
            .map((e) => TronNetworkToken(
                status: NetworkTokenFetchingStatus.success,
                token: TronTRC20Token.create(
                    balance: e.balance,
                    token: Token(
                        name: e.tokenAbbr,
                        symbol: e.tokenName,
                        decimal: e.tokenDecimal,
                        assetLogo: APPImage.network(e.tokenLogo)),
                    contractAddress: TronAddress(e.tokenId))))
            .toList();
        max = tronscanAssets.result.tokens.length;
        offset++;
        add(tc20Assets);
      }
      close();
    }

    controller.onListen = fetchTokens;
    controller.onCancel = close;

    return controller.stream;
  }

  @override
  Future<bool> onInit() async {
    final result = await MethodUtils.call<bool>(() async {
      return await checkGenesis();
    });
    if (result.hasResult && result.result) {
      final chainIdResult = await MethodUtils.call<bool>(() async {
        return await checkSolidityChainId();
      });
      return chainIdResult.hasResult && chainIdResult.result;
    }

    return false;
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    try {
      final r =
          await provider.request(TronRequestGetTransactionById(value: txId));
      if (r == null) return WalletTransactionStatus.unknown;
      if (r.isSuccess) return WalletTransactionStatus.block;
      return WalletTransactionStatus.unknown;
    } catch (_) {
      return WalletTransactionStatus.unknown;
    }
  }

  @override
  NetworkType get networkType => NetworkType.tron;
}
