import 'package:on_chain_wallet/app/utils/list/extension.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/constant/constants/constant.dart';

class Web3MoneroRequestMethods extends Web3NetworkRequestMethods {
  const Web3MoneroRequestMethods._({required super.id, required super.name});

  static const Web3MoneroRequestMethods requestAccounts =
      Web3MoneroRequestMethods._(
          id: Web3MoneroConst.requestAccountTag,
          name: Web3MoneroConst.requestAccounts);
  static const Web3MoneroRequestMethods signMessage =
      Web3MoneroRequestMethods._(
          id: Web3MoneroConst.signMessageTag,
          name: Web3MoneroConst.signMessage);

  static const Web3MoneroRequestMethods sendTransaction =
      Web3MoneroRequestMethods._(
          id: Web3MoneroConst.sendTransactionTag,
          name: Web3MoneroConst.sendTransaction);

  @override
  NetworkType get network => NetworkType.monero;

  static List<Web3MoneroRequestMethods> values = [
    requestAccounts,
    sendTransaction,
    signMessage
  ];

  static Web3MoneroRequestMethods fromId(int? id) {
    return values.firstWhere((e) => e.id == id,
        orElse: () => throw Web3RequestExceptionConst.methodDoesNotExist);
  }

  static Web3MoneroRequestMethods? fromName(String? name) {
    return values.firstWhereOrNull(
        (e) => e.name == name || e.methodsName.contains(name));
  }
}
