import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/models/transaction.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/permission/models/account.dart';

class Web3BitcoinCashSignTransaction extends Web3BitcoinCashRequestParam<String>
    implements
        BaseWeb3BitcoinSignTransaction<IBitcoinCashAddress,
            Web3BitcoinCashChainAccount> {
  @override
  final List<Web3BitcoinCashChainAccount> accounts;
  @override
  final Web3BitcoinCashChainAccount accessAccount;
  @override
  final Psbt psbt;

  Web3BitcoinCashSignTransaction._({
    required this.accounts,
    required this.psbt,
    required this.accessAccount,
  });
  factory Web3BitcoinCashSignTransaction(
      {required List<Web3BitcoinCashChainAccount> accounts,
      required Psbt psbt}) {
    final networks = accounts.map((e) => e.id).toSet();
    if (networks.length != 1) {
      throw Web3RequestExceptionConst.internalError;
    }
    return Web3BitcoinCashSignTransaction._(
        accounts: accounts, psbt: psbt, accessAccount: accounts[0]);
  }

  factory Web3BitcoinCashSignTransaction.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: object,
        tags: Web3MessageTypes.walletRequest.tag);
    return Web3BitcoinCashSignTransaction(
        accounts: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) => Web3BitcoinCashChainAccount.deserialize(object: e))
            .toList(),
        psbt: Psbt.deserialize(values.elementAs(2)));
  }

  @override
  Web3BitcoinCashRequestMethods get method =>
      Web3BitcoinCashRequestMethods.signTransaction;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          method.tag,
          CborSerializable.fromDynamic(
              accounts.map((e) => e.toCbor()).toList()),
          CborBytesValue(psbt.serialize())
        ]),
        type.tag);
  }

  @override
  Future<Web3BitcoinCashRequest<String, Web3BitcoinCashSignTransaction>>
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
    return Web3BitcoinCashRequest<String, Web3BitcoinCashSignTransaction>(
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
