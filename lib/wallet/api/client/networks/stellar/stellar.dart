import 'dart:async';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/stellar.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/constant/networks/stellar.dart';
import 'package:on_chain_wallet/wallet/models/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/stellar/stellar.dart';
import 'package:on_chain_wallet/wallet/models/token/network/token.dart';
import 'package:on_chain_wallet/wallet/models/token/token/token.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/stellar.dart';
import 'package:stellar_dart/stellar_dart.dart';

class StellarClient extends NetworkClient<StellarWalletTransaction,
    StellarAPIProvider, StellarNetworkToken, StellarAddress> with HttpImpl {
  StellarClient({required this.provider, required this.network});
  final StellarProvider provider;
  @override
  final WalletStellarNetwork network;
  @override
  NetworkServiceProtocol<StellarAPIProvider> get service =>
      provider.rpc as NetworkServiceProtocol<StellarAPIProvider>;

  Future<StellarAccountResponse?> getAccount(StellarAddress address) async {
    try {
      return await provider.request(HorizonRequestAccount(address.baseAddress));
    } on ApiProviderException catch (e) {
      if (e.statusCode == ServiceConst.notFoundStatusCode) return null;
      rethrow;
    }
  }

  Future<StellarAllTransactionResponse?> submitTx(String envelopeXdr) async {
    final r = await provider
        .requestDynamic(HorizonRequestSubmitTransaction(envelopeXdr));
    try {
      return StellarAllTransactionResponse.fromJson(r);
    } catch (e) {
      return null;
    }
  }

  Future<int> getBaseReserve() async {
    final result = await provider.request(const HorizonRequestLedgers());
    return result.first.baseReserveInStroops;
  }

  Future<StellarFeeStatsResponse> feeState() async {
    final result = await provider.request(const HorizonRequestFeeStats());
    return result;
  }

  Future<String> passphrase() async {
    final result = await provider.request(SorobanRequestGetNetwork());
    return result.passphrase;
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    try {
      final r = await provider.requestDynamic(HorizonRequestTransaction(txId));
      final tx = MethodUtils.nullOnException(
          () => StellarTransactionResponse.fromJson(r));
      if (tx != null && !tx.successful) {
        return WalletTransactionStatus.failed;
      }
      return WalletTransactionStatus.block;
    } catch (_) {
      return WalletTransactionStatus.unknown;
    }
  }

  Future<void> _fetchTokenMetadata(StellarNetworkToken token) async {
    if (!token.status.allowRetry) return;
    token.setPending();
    final metadat = await MethodUtils.call(() async {
      final tokenData = await provider.request(HorizonRequestAssets(
          assetCode: token.token.assetCode, assetIssuer: token.token.issuer));
      final currentToken = tokenData.firstWhereOrNull((e) =>
          e.assetCode == token.token.assetCode &&
          e.assetIssuer == token.token.issuer);
      final tomlUrl = currentToken?.link.toml.href;
      if (tomlUrl == null) {
        return null;
      }
      final tomlData = await httpGet<String>(tomlUrl);
      final metadata =
          StellarAssetMetadata.fromToml(tomlData.resultOrNull ?? '');
      return metadata.firstWhere((e) =>
          e.code == token.token.assetCode &&
          e.issuer.address == token.token.issuer);
    });
    final result = metadat.resultOrNull;
    if (result == null) {
      token.setError();
      return;
    }
    final updatedToken = token.token.updateToken(Token(
        name: result.name,
        symbol: result.code,
        decimal: StellarConst.decimal,
        assetLogo: APPImage.network(result.image)));
    token.setSuccess(updatedToken);
  }

  @override
  Stream<List<StellarNetworkToken>> getAccountTokensStream(
      StellarAddress address) {
    final controller = StreamController<List<StellarNetworkToken>>();

    Future<void> fetchTokens() async {
      final account = await MethodUtils.call(() async {
        return await getAccount(address);
      });
      final result = account.result;
      if (account.hasError) {
        controller.addError(account.exception!);
        controller.close();
        return;
      }

      if (result == null) {
        controller.close();
        return;
      }
      final tokens = result.balances
          .whereType<StellarAssetBalanceResponse>()
          .map((e) => e.toIssueToken())
          .map((e) => StellarNetworkToken(token: e))
          .toList();
      controller.add(tokens);
      for (final i in tokens) {
        _fetchTokenMetadata(i);
      }
      controller.close();
    }

    fetchTokens();

    return controller.stream;
  }

  @override
  Future<bool> onInit() async {
    final result = await MethodUtils.call(() async => await passphrase());
    return result.hasResult &&
        result.result == network.coinParam.stellarChainType.passphrase;
  }

  @override
  NetworkType get networkType => NetworkType.stellar;
}
