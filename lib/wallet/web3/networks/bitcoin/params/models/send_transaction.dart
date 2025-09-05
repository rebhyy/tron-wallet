import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/constant/constants/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/permission/models/account.dart';

class Web3BitcoinSendTransactionOutput with CborSerializable {
  final BigInt value;
  final Script scriptPubKey;
  final String? address;
  const Web3BitcoinSendTransactionOutput._(
      {required this.value, required this.scriptPubKey, required this.address});

  factory Web3BitcoinSendTransactionOutput(
      {required BigInt value,
      required Script scriptPubKey,
      required String? address}) {
    if (value.isNegative) {
      throw Web3RequestExceptionConst.failedToParse("value");
    }
    return Web3BitcoinSendTransactionOutput._(
        value: value, scriptPubKey: scriptPubKey, address: address);
  }
  factory Web3BitcoinSendTransactionOutput.deserialize(
      {List<int>? cborBytes, String? cborHex, CborObject? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: cborBytes,
        hex: cborHex,
        object: object,
        tags: CborTagsConst.defaultTag);
    return Web3BitcoinSendTransactionOutput(
        value: values.elementAs(0),
        scriptPubKey: Script.deserialize(bytes: values.elementAs(1)),
        address: values.elementAs(2));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [value, CborBytesValue(scriptPubKey.toBytes()), address]),
        CborTagsConst.defaultTag);
  }
}

abstract class BaseWeb3BitcoinSendTransaction<ADDRESS extends IBitcoinAddress,
        WEB3CHAINACCOUNT extends Web3BitcoinChainAccount>
    extends BaseWeb3BitcoinRequestParam<String, ADDRESS, WEB3CHAINACCOUNT> {
  abstract final List<WEB3CHAINACCOUNT> accounts;
  abstract final WEB3CHAINACCOUNT accessAccount;
  abstract final List<Web3BitcoinSendTransactionOutput> outputs;
  abstract final WEB3CHAINACCOUNT? requiredAccount;
}

class Web3BitcoinSendTransaction extends Web3BitcoinRequestParam<String>
    implements
        BaseWeb3BitcoinSendTransaction<IBitcoinAddress,
            Web3BitcoinChainAccount> {
  @override
  final List<Web3BitcoinChainAccount> accounts;
  @override
  final Web3BitcoinChainAccount accessAccount;
  @override
  final List<Web3BitcoinSendTransactionOutput> outputs;
  @override
  final Web3BitcoinChainAccount? requiredAccount;

  Web3BitcoinSendTransaction._({
    required List<Web3BitcoinChainAccount> accounts,
    required List<Web3BitcoinSendTransactionOutput> outputs,
    required this.accessAccount,
    this.requiredAccount,
  })  : accounts = accounts.immutable,
        outputs = outputs.immutable;
  factory Web3BitcoinSendTransaction(
      {required List<Web3BitcoinChainAccount> accounts,
      required List<Web3BitcoinSendTransactionOutput> outputs,
      Web3BitcoinChainAccount? requiredAccount}) {
    final networks = accounts.map((e) => e.id).toSet();
    if (networks.length != 1) {
      throw Web3RequestExceptionConst.internalError;
    }
    if (requiredAccount != null && !accounts.contains(requiredAccount)) {
      throw Web3RequestExceptionConst.internalError;
    }
    if (outputs.isEmpty) {
      throw Web3BitcoinExceptionConstant.emptyOutput;
    }
    return Web3BitcoinSendTransaction._(
        accounts: accounts,
        outputs: outputs,
        accessAccount: accounts[0],
        requiredAccount: requiredAccount);
  }

  factory Web3BitcoinSendTransaction.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: object,
        tags: Web3MessageTypes.walletRequest.tag);
    return Web3BitcoinSendTransaction(
        accounts: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) => Web3BitcoinChainAccount.deserialize(object: e))
            .toList(),
        outputs: values
            .elementAsListOf<CborTagValue>(2)
            .map((e) => Web3BitcoinSendTransactionOutput.deserialize(object: e))
            .toList(),
        requiredAccount:
            values.elemetMybeAs<Web3BitcoinChainAccount, CborTagValue>(
                3, (e) => Web3BitcoinChainAccount.deserialize(object: e)));
  }

  @override
  Web3BitcoinRequestMethods get method =>
      Web3BitcoinRequestMethods.sendTransaction;

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
  Future<Web3BitcoinRequest<String, Web3BitcoinSendTransaction>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<IBitcoinAddress, BitcoinChain,
              Web3BitcoinChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3BitcoinRequest<String, Web3BitcoinSendTransaction>(
      params: this,
      authenticated: authenticated,
      chain: chain.$1,
      info: request,
      accounts: chain.$2,
    );
  }

  @override
  List<Web3BitcoinChainAccount> get requiredAccounts => accounts;
}
