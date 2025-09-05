import 'package:on_chain_wallet/app/utils/list/extension.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/constant/constants/constant.dart';

class Web3ADARequestMethods extends Web3NetworkRequestMethods {
  const Web3ADARequestMethods._({required super.id, required super.name});

  static const Web3ADARequestMethods requestAccounts = Web3ADARequestMethods._(
      id: Web3ADAConst.requestAccountTag, name: Web3ADAConst.requestAccounts);
  static const Web3ADARequestMethods signMessage = Web3ADARequestMethods._(
      id: Web3ADAConst.signMessageTag, name: Web3ADAConst.signMessage);
  static const Web3ADARequestMethods signTransaction = Web3ADARequestMethods._(
      id: Web3ADAConst.signTransactionTag, name: Web3ADAConst.signTransaction);

  ///
  static const Web3ADARequestMethods isEnabled = Web3ADARequestMethods._(
      id: Web3ADAConst.isEnabledTag, name: Web3ADAConst.isEnabled);
  static const Web3ADARequestMethods getNetworkId = Web3ADARequestMethods._(
      id: Web3ADAConst.getNetworkIdTag, name: Web3ADAConst.getNetworkId);
  static const Web3ADARequestMethods getBalance = Web3ADARequestMethods._(
      id: Web3ADAConst.getBalanceTag, name: Web3ADAConst.getBalance);
  static const Web3ADARequestMethods getUtxos = Web3ADARequestMethods._(
      id: Web3ADAConst.getUtxosTag, name: Web3ADAConst.getUtxos);

  static const Web3ADARequestMethods getAddressUtxos = Web3ADARequestMethods._(
      id: Web3ADAConst.getAddressUtxosTag, name: Web3ADAConst.getAddressUtxos);
  static const Web3ADARequestMethods getUnusedAddresses =
      Web3ADARequestMethods._(
          id: Web3ADAConst.getUnusedAddressesTag,
          name: Web3ADAConst.getUnusedAddresses);
  static const Web3ADARequestMethods getUsedAddresses = Web3ADARequestMethods._(
      id: Web3ADAConst.getUsedAddressesTag,
      name: Web3ADAConst.getUsedAddresses);
  static const Web3ADARequestMethods getRewardAddresses =
      Web3ADARequestMethods._(
          id: Web3ADAConst.getRewardAddressesTag,
          name: Web3ADAConst.getRewardAddresses);
  static const Web3ADARequestMethods getCollateral = Web3ADARequestMethods._(
      id: Web3ADAConst.getCollateralTag, name: Web3ADAConst.getCollateral);
  static const Web3ADARequestMethods getChangeAddress = Web3ADARequestMethods._(
      id: Web3ADAConst.getChangeAddressTag,
      name: Web3ADAConst.getChangeAddress);

  static const Web3ADARequestMethods signData = Web3ADARequestMethods._(
      id: Web3ADAConst.signDataTag, name: Web3ADAConst.signData);
  static const Web3ADARequestMethods getExtensions = Web3ADARequestMethods._(
      id: Web3ADAConst.getExtensionsTag, name: Web3ADAConst.getExtensions);
  static const Web3ADARequestMethods submitTx = Web3ADARequestMethods._(
      id: Web3ADAConst.submitTxTag, name: Web3ADAConst.submitTx);
  static const Web3ADARequestMethods signTx = Web3ADARequestMethods._(
      id: Web3ADAConst.signTxTag, name: Web3ADAConst.signTx);
  static const Web3ADARequestMethods signAndSendTransaction =
      Web3ADARequestMethods._(
          id: Web3ADAConst.signAndSendTransactionTag,
          name: Web3ADAConst.sendTransaction);

  static const Web3ADARequestMethods submitTxs = Web3ADARequestMethods._(
      id: Web3ADAConst.submitTxsTag, name: Web3ADAConst.submitTxs);
  static const Web3ADARequestMethods signTxs = Web3ADARequestMethods._(
      id: Web3ADAConst.signTxsTag, name: Web3ADAConst.signTxs);

  static const Web3ADARequestMethods getAccountPub = Web3ADARequestMethods._(
      id: Web3ADAConst.getAccountPubTag, name: Web3ADAConst.getAccountPub);
  //
  static const Web3ADARequestMethods getScriptRequirements =
      Web3ADARequestMethods._(
          id: Web3ADAConst.getScriptRequirementsTag,
          name: Web3ADAConst.getScriptRequirements);
  static const Web3ADARequestMethods getScript = Web3ADARequestMethods._(
      id: Web3ADAConst.getScriptTag, name: Web3ADAConst.getScript);
  static const Web3ADARequestMethods submitUnsignedTx = Web3ADARequestMethods._(
      id: Web3ADAConst.submitUnsignedTxTag,
      name: Web3ADAConst.submitUnsignedTx);
  static const Web3ADARequestMethods getCompletedTx = Web3ADARequestMethods._(
      id: Web3ADAConst.getCompletedTxTag, name: Web3ADAConst.getCompletedTx);
  @override
  NetworkType get network => NetworkType.cardano;

  static List<Web3ADARequestMethods> values = [
    signMessage,
    signTransaction,
    requestAccounts,
    signAndSendTransaction,
    getAddressUtxos,

    //
    getScriptRequirements,
    getScript,
    submitUnsignedTx,
    getCompletedTx,
    submitTxs,
    signTxs,
    getUnusedAddresses,
    getChangeAddress,
    getCollateral,
    getUsedAddresses,
    isEnabled,
    getNetworkId,
    getBalance,
    getUtxos,
    signTx,
    signData,
    getExtensions,
    submitTx,
    getRewardAddresses,
    getAccountPub
  ];

  static Web3ADARequestMethods fromId(int? id) {
    return values.firstWhere((e) => e.id == id,
        orElse: () => throw Web3RequestExceptionConst.methodDoesNotExist);
  }

  static Web3ADARequestMethods? fromName(String? name) {
    return values.firstWhereOrNull(
        (e) => e.name == name || e.methodsName.contains(name));
  }
}
