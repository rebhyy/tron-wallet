import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/models/send_transaction.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/constant/constants/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/permission/models/account.dart';

class Web3BitcoinCashSendTransaction extends Web3BitcoinCashRequestParam<String>
    implements
        BaseWeb3BitcoinSendTransaction<IBitcoinCashAddress,
            Web3BitcoinCashChainAccount> {
  @override
  final List<Web3BitcoinCashChainAccount> accounts;
  @override
  final Web3BitcoinCashChainAccount accessAccount;
  @override
  final List<Web3BitcoinSendTransactionOutput> outputs;
  @override
  final Web3BitcoinCashChainAccount? requiredAccount;

  Web3BitcoinCashSendTransaction._({
    required List<Web3BitcoinCashChainAccount> accounts,
    required List<Web3BitcoinSendTransactionOutput> outputs,
    required this.accessAccount,
    this.requiredAccount,
  })  : accounts = accounts.immutable,
        outputs = outputs.immutable;
  factory Web3BitcoinCashSendTransaction(
      {required List<Web3BitcoinCashChainAccount> accounts,
      required List<Web3BitcoinSendTransactionOutput> outputs,
      Web3BitcoinCashChainAccount? requiredAccount}) {
    final networks = accounts.map((e) => e.id).toSet();
    if (networks.length != 1) {
      throw Web3RequestExceptionConst.internalError;
    }
    if (requiredAccount != null && !accounts.contains(requiredAccount)) {
      throw Web3RequestExceptionConst.internalError;
    }
    if (outputs.isEmpty) {
      throw Web3BitcoinCashExceptionConstant.emptyOutput;
    }
    return Web3BitcoinCashSendTransaction._(
        accounts: accounts,
        outputs: outputs,
        accessAccount: accounts[0],
        requiredAccount: requiredAccount);
  }

  factory Web3BitcoinCashSendTransaction.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: object,
        tags: Web3MessageTypes.walletRequest.tag);
    return Web3BitcoinCashSendTransaction(
        accounts: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) => Web3BitcoinCashChainAccount.deserialize(object: e))
            .toList(),
        outputs: values
            .elementAsListOf<CborTagValue>(2)
            .map((e) => Web3BitcoinSendTransactionOutput.deserialize(object: e))
            .toList(),
        requiredAccount:
            values.elemetMybeAs<Web3BitcoinCashChainAccount, CborTagValue>(
                3, (e) => Web3BitcoinCashChainAccount.deserialize(object: e)));
  }

  @override
  Web3BitcoinCashRequestMethods get method =>
      Web3BitcoinCashRequestMethods.sendTransaction;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          method.tag,
          CborSerializable.fromDynamic(
              accounts.map((e) => e.toCbor()).toList()),
          CborSerializable.fromDynamic(outputs.map((e) => e.toCbor()).toList()),
          requiredAccount?.toCbor()
        ]),
        type.tag);
  }

  @override
  Future<Web3BitcoinCashRequest<String, Web3BitcoinCashSendTransaction>>
      toRequest(
          {required Web3RequestInformation request,
          required Web3RequestAuthentication authenticated,
          required WEB3REQUESTNETWORKCONTROLLER<IBitcoinCashAddress,
                  BitcoinChain, Web3BitcoinCashChainAccount>
              chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3BitcoinCashRequest<String, Web3BitcoinCashSendTransaction>(
      params: this,
      authenticated: authenticated,
      chain: chain.$1,
      info: request,
      accounts: chain.$2,
    );
  }

  @override
  List<Web3BitcoinCashChainAccount> get requiredAccounts => accounts;
}
