import 'package:on_chain_wallet/app/utils/list/extension.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/constant/constants/constant.dart';

class Web3XRPRequestMethods extends Web3NetworkRequestMethods {
  const Web3XRPRequestMethods._({required super.id, required super.name});

  static const Web3XRPRequestMethods requestAccounts = Web3XRPRequestMethods._(
      id: Web3XRPConst.requestAccountTag, name: Web3XRPConst.requestAccounts);
  static const Web3XRPRequestMethods signMessage = Web3XRPRequestMethods._(
      id: Web3XRPConst.signMessageTag, name: Web3XRPConst.signMessage);

  static const Web3XRPRequestMethods signTransaction = Web3XRPRequestMethods._(
      id: Web3XRPConst.signTransactionTag, name: Web3XRPConst.signTransaction);

  static const Web3XRPRequestMethods sendTransaction = Web3XRPRequestMethods._(
      id: Web3XRPConst.sendTransactionTag, name: Web3XRPConst.sendTransaction);

  @override
  NetworkType get network => NetworkType.xrpl;

  static List<Web3XRPRequestMethods> values = [
    requestAccounts,
    signTransaction,
    sendTransaction,
    signMessage
  ];

  static Web3XRPRequestMethods fromId(int? id) {
    return values.firstWhere((e) => e.id == id,
        orElse: () => throw Web3RequestExceptionConst.methodDoesNotExist);
  }

  static Web3XRPRequestMethods? fromName(String? name) {
    return values.firstWhereOrNull(
        (e) => e.name == name || e.methodsName.contains(name));
  }
}
