import 'dart:async';

import 'package:blockchain_utils/exception/exceptions.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/ripple/methods/methods.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/ripple/types/types.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/ripple/utils/utils.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/ripple.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/models/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/ripple/ripple.dart';
import 'package:on_chain_wallet/wallet/models/token/token.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/xrp.dart';
import 'package:xrpl_dart/xrpl_dart.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';

class _RippleApiProviderConst {
  static const int accountNotFound = 19;
  static const int avarageDayLedger = 200000;
  static const int rippleEpochTime = 946684800;
}

class XRPClient extends NetworkClient<XRPWalletTransaction, RippleAPIProvider,
    RippleNetworkToken, XRPAddress> with HttpImpl {
  XRPClient({required this.provider, required this.network});
  final XRPProvider provider;
  @override
  final WalletXRPNetwork network;

  @override
  NetworkServiceProtocol<RippleAPIProvider> get service =>
      provider.rpc as NetworkServiceProtocol<RippleAPIProvider>;

  Future<BigInt> getAccountBalance(XRPAddress address) async {
    final accountInfo = await getAccountInfo(address.address);
    if (accountInfo == null) return BigInt.zero;
    return BigintUtils.parse(accountInfo.accountData.balance);
  }

  Future<int> getAccountSequence(XRPAddress address) async {
    final accountInfo = await provider.request(XRPRequestAccountInfo(
        account: address.address, ledgerIndex: XRPLLedgerIndex.current));
    return accountInfo.accountData.sequence;
  }

  Future<int> getLedgerIndex() async {
    final index = await provider.request(XRPRequestLedgerCurrent());
    return index;
  }

  Future<SimulateResult> simulateTx(SubmittableTransaction transaction) async {
    return await provider
        .request(XRPRequestSimulateTx(txBlob: transaction.toTransactionBlob()));
  }

  Future<List<XRPIssueToken>> getAccountTokens(XRPAddress address) async {
    return await provider.request(XRPRPCFetchTokens(account: address));
  }

  Future<int> getCurrentLedger() async {
    return await provider.request(XRPRequestLedgerCurrent());
  }

  Future<int> getLedgerDateTime(int index) async {
    final ledger = await provider.request(
        XRPRequestLedger(ledgerIndex: XRPLLedgerIndex.index(index.toString())));
    return ledger.closeTime;
  }

  Future<XRPLAccountTxs> getAccountTxes(
      {required XRPAddress address, int? ledger}) async {
    dynamic marker;
    if (ledger == null) {
      final current = await getCurrentLedger();
      ledger = current - _RippleApiProviderConst.avarageDayLedger;
      assert(ledger > 0);
    }
    List<XRPLAccountTx> transactions = [];
    int ledgerIndexMax = ledger;
    while (true) {
      final txes = await provider.request(XRPRequestAccountTx(
          account: address.address,
          binary: false,
          ledgerIndexMin: ledger,
          marker: marker));
      ledgerIndexMax = txes.ledgerIndexMax;
      for (final i in txes.transactions) {
        if (i.txJson == null) continue;
        final validate = i.validated ?? false;
        final int? date = i.txJson!.date;
        assert(i.txJson?.hash != null);
        if (validate && date == null || i.txJson!.hash == null) continue;
        transactions.add(XRPLAccountTx(
            transaction: i.txJson!,
            txId: i.txJson!.hash!,
            ledgerTime: date == null
                ? null
                : DateTimeUtils.fromSecondsSinceEpoch(
                    date + _RippleApiProviderConst.rippleEpochTime)));
      }
      if (txes.marker == null) break;
      marker = txes.marker;
    }
    return XRPLAccountTxs(
        txes: transactions, latestLedger: ledgerIndexMax, address: address);
  }

  Future<XRPAccountObjectEntry?> getAccountSignerList(String address) async {
    try {
      return await provider
          .request(XRPRPCSignerAccountObject(account: address));
    } on RPCError catch (e) {
      if (e.errorCode == _RippleApiProviderConst.accountNotFound) {
        return null;
      }
      rethrow;
    }
  }

  Future<BaseAccountInfoResponse?> getAccountInfo(String address) async {
    try {
      return await provider.request(XRPRequestAccountInfo(account: address));
    } on RPCError catch (e) {
      if (e.errorCode == _RippleApiProviderConst.accountNotFound) {
        return null;
      }
      rethrow;
    }
  }

  Future<(String?, XRPAccountObjectEntry?)?> getAccountRegularAndSignerList(
      String address) async {
    final account = await getAccountInfo(address);
    if (account == null) return null;
    final signers = await getAccountSignerList(address);
    if (signers == null && account.accountData.regularKey == null) {
      return null;
    }
    final signerObject =
        (signers?.signerEntries.isEmpty ?? true) ? null : signers!;
    return (account.accountData.regularKey, signerObject);
  }

  Future<List<RippleIssueToken>> accountTokens(IXRPAddress address) async {
    final tokens = await provider
        .request(XRPRPCFetchTokens(account: address.networkAddress));
    return tokens
        .map((e) => RippleIssueToken.create(
            balance: e.balance,
            token: NonDecimalToken(name: e.currency, symbol: e.currency),
            issuer: e.issuer.address,
            assetCode: e.currency))
        .toList();
  }

  Future<List<RippleIssueToken>> _accountTokens(XRPAddress address) async {
    final tokens = await provider
        .request(XRPRPCFetchTokens(account: address, allowObligations: false));
    return tokens
        .map((e) => RippleIssueToken.create(
            balance: e.balance,
            token: NonDecimalToken(name: e.currency, symbol: e.currency),
            issuer: e.issuer.address,
            assetCode: e.currency))
        .toList();
  }

  Future<ServerInfoResult> getServerInfo() async {
    return await provider.request(XRPRequestServerInfo());
  }

  Future<SubmitResult> sendTransaction(String blob) async {
    return await provider.request(XRPRequestSubmit(txBlob: blob));
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    try {
      return await provider
          .request(XRPRequestTransactionStatus(transaction: txId));
    } catch (_) {
      return WalletTransactionStatus.unknown;
    }
  }

  Future<void> _fetchTokenMetadata(RippleNetworkToken token) async {
    if (!token.status.allowRetry) return;
    if (!network.coinParam.chainType.isMainnet) {
      token.setSuccess();
      return;
    }
    token.setPending();
    final result = await MethodUtils.call(() async {
      final metadata = await httpGet<Map<String, dynamic>>(
          RippleClientUtils.buildXrplMetaUrl(
              token.token.assetCode, token.token.issuer),
          headers: HttpCallerUtils.applicationJsonContentType,
          responseType: HTTPResponseType.map);
      return XRPLMetaAsset.fromJson(metadata.result);
    });

    final metadata = result.resultOrNull;
    if (metadata == null) {
      token.setSuccess();
      return;
    }
    final updateToken = Token(
        name: token.token.token.name,
        symbol: token.token.token.symbol,
        decimal: 0,
        assetLogo: APPImage.network(metadata.meta.token.icon));
    token.updaetTokenMetadata(updateToken);
  }

  @override
  Stream<List<RippleNetworkToken>> getAccountTokensStream(XRPAddress address) {
    final controller = StreamController<List<RippleNetworkToken>>();
    void add(List<RippleIssueToken> splTokens) {
      final tokens =
          splTokens.map((e) => RippleNetworkToken(token: e)).toList();
      if (!controller.isClosed) {
        controller.add(tokens);
        for (final i in tokens) {
          _fetchTokenMetadata(i);
        }
      }
    }

    void error(Object err) {
      if (!controller.isClosed) controller.addError(err);
    }

    void close() {
      if (!controller.isClosed) controller.close();
    }

    Future<void> fetchTokens() async {
      final tokens = await MethodUtils.call(() async {
        return _accountTokens(address);
      });
      if (tokens.hasError) {
        error(tokens.exception!);
        close();
        return;
      }
      add(tokens.result);
      close();
    }

    controller.onListen = fetchTokens;
    controller.onCancel = close;

    return controller.stream;
  }

  @override
  Future<bool> onInit() async {
    final result = await MethodUtils.call(() async {
      return getServerInfo();
    });
    return result.hasResult &&
        result.result.info.networkId == network.coinParam.networkId;
  }

  @override
  NetworkType get networkType => NetworkType.xrpl;
}
