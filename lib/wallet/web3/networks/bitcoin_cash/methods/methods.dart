import 'package:on_chain_wallet/app/utils/list/extension.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/constant/constants/constant.dart';

class Web3BitcoinCashRequestMethods extends Web3BitcoinRequestMethods {
  const Web3BitcoinCashRequestMethods._(
      {required super.id, required super.name, super.methodsName});

  static const Web3BitcoinCashRequestMethods requestAccounts =
      Web3BitcoinCashRequestMethods._(
          id: Web3BitcoinCashConst.requestAccountTag,
          name: Web3BitcoinCashConst.requestAccounts);

  static const Web3BitcoinCashRequestMethods signPersonalMessage =
      Web3BitcoinCashRequestMethods._(
          id: Web3BitcoinCashConst.signPersonalMessagTag,
          name: Web3BitcoinCashConst.signPersonalMessage);

  static const Web3BitcoinCashRequestMethods signMessage =
      Web3BitcoinCashRequestMethods._(
          id: Web3BitcoinCashConst.signMessageTag,
          name: Web3BitcoinCashConst.signMessage);

  static const Web3BitcoinCashRequestMethods signTransaction =
      Web3BitcoinCashRequestMethods._(
          id: Web3BitcoinCashConst.signTransactionTag,
          name: Web3BitcoinCashConst.signTransaction,
          methodsName: [Web3BitcoinCashConst.signPsbt]);

  static const Web3BitcoinCashRequestMethods getAccountAddresses =
      Web3BitcoinCashRequestMethods._(
          id: Web3BitcoinCashConst.getAccountAddressesTag,
          name: Web3BitcoinCashConst.getAccountAddresses,
          methodsName: [Web3BitcoinCashConst.bitcoinGetAccountAddresses]);

  static const Web3BitcoinCashRequestMethods sendTransaction =
      Web3BitcoinCashRequestMethods._(
          id: Web3BitcoinCashConst.sendTransactionTag,
          name: Web3BitcoinCashConst.sendTransaction,
          methodsName: [Web3BitcoinCashConst.sendTransfer]);

  @override
  NetworkType get network => NetworkType.bitcoinCash;

  static List<Web3BitcoinCashRequestMethods> values = [
    requestAccounts,
    signTransaction,
    signPersonalMessage,
    sendTransaction,
    signMessage,
    getAccountAddresses
  ];

  static Web3BitcoinCashRequestMethods fromId(int? id) {
    return values.firstWhere((e) => e.id == id,
        orElse: () => throw Web3RequestExceptionConst.methodDoesNotExist);
  }

  static Web3BitcoinCashRequestMethods? fromName(String? name) {
    return values.firstWhereOrNull(
        (e) => e.name == name || e.methodsName.contains(name));
  }
}
