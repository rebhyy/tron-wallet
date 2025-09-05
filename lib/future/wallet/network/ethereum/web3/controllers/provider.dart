import 'package:blockchain_utils/exception/exception/rpc_error.dart';
import 'package:blockchain_utils/utils/binary/utils.dart';
import 'package:blockchain_utils/utils/string/string.dart';
import 'package:on_chain/ethereum/src/address/evm_address.dart';
import 'package:on_chain/ethereum/src/transaction/eth_transaction.dart';
import 'package:on_chain/solidity/address/core.dart';
import 'package:on_chain/solidity/contract/contract_abi.dart';
import 'package:on_chain/tron/src/address/tron_address.dart';
import 'package:on_chain_wallet/app/utils/method/utiils.dart';
import 'package:on_chain_wallet/app/utils/platform/utils.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/crypto/utils/solidity/solidity.dart';
import 'package:on_chain_wallet/future/wallet/network/ethereum/web3/types/types.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ethereum/params/models/send_transaction.dart';

mixin SolidityWeb3TransactionApiController {
  EthereumClient get solidityClient;

  Future<Web3EthereumTransactionRequestInfos> getWeb3TransactionInfos(
      {required IEthAddress from,
      required Web3EthreumSendTransaction transaction,
      required EthereumChain chain}) async {
    final ReceiptAddress<ETHAddress>? destination = transaction.to != null
        ? chain.getReceiptAddress(transaction.to!.address) ??
            ReceiptAddress<ETHAddress>(
                view: transaction.to!.address, networkAddress: transaction.to!)
        : null;
    EthereumTransactionDataInfo? contractInfos;
    ETHTransactionType? type = transaction.transactionType;
    if (type == null) {
      type = chain.network.coinParam.supportEIP1559
          ? ETHTransactionType.eip1559
          : ETHTransactionType.legacy;
    } else if (type == ETHTransactionType.eip2930 &&
        transaction.gasPrice == null &&
        chain.network.coinParam.supportEIP1559) {
      type = ETHTransactionType.eip1559;
    }
    if (transaction.to != null) {
      final bool isSmartContract =
          await solidityClient.isContract(transaction.to!);
      if (!isSmartContract) {
        return Web3EthereumTransactionRequestInfos(
            transaction: transaction,
            destination: destination,
            type: type,
            contractInfo: transaction.data.isEmpty
                ? null
                : UnknownTransactionData.fromBytes(transaction.data),
            network: chain.network);
      }
      contractInfos = await getTransactionContractInfo(
          account: from.networkAddress,
          contractAddress: transaction.to!,
          data: transaction.data,
          chain: chain);
    }
    if (transaction.to == null && transaction.data.isNotEmpty) {
      contractInfos ??= SolidityCreationContract();
    } else if (transaction.data.isNotEmpty) {
      contractInfos ??= UnknownTransactionData.fromBytes(transaction.data);
    }

    return Web3EthereumTransactionRequestInfos(
        transaction: transaction,
        destination: destination,
        type: type,
        contractInfo: contractInfos,
        network: chain.network);
  }

  Future<EthereumTransactionDataInfo>
      __getTransactionContractInfo<NETWORKADDRESS extends SolidityAddress>(
          {required ContractABI? contract,
          required SolidityAddress contractAddress,
          required SolidityAddress account,
          required Chain chain,
          required List<int> data,
          required String dataHex,
          required List<int> selector,
          required SolidityContractInterface? interface}) async {
    if (contract == null || interface == SolidityContractInterface.erc20) {
      final token = await _getAccountERC20Token(account, contractAddress);
      if (token != null) {
        if (BytesUtils.bytesEqual(
            selector, SolidityContractUtils.erc20Transfer.selector)) {
          final decodeTransfer = MethodUtils.nullOnException(() {
            final decode = SolidityContractUtils.decodeErc20Transfer(data);
            if (chain.network.type == NetworkType.tron) {
              return (decode.a.toTronAddress(), decode.b);
            }
            return (decode.a.toEthereumAddress(), decode.b);
          });
          if (decodeTransfer != null) {
            final to = chain.getReceiptAddress(decodeTransfer.$1.toString()) ??
                ReceiptAddress<NETWORKADDRESS>(
                    view: decodeTransfer.$1.toString(),
                    networkAddress: decodeTransfer.$1 as NETWORKADDRESS);
            return SolidityERC20TransferMethodInfo<NETWORKADDRESS>(
                selector: selector,
                token: token,
                to: to as ReceiptAddress<NETWORKADDRESS>,
                value: IntegerBalance.token(decodeTransfer.$2, token.token),
                dataHex: dataHex);
          }
        }
        if (contract == null) {
          final contractJson = await PlatformUtils.loadAssetText(
              SolidityContractInterface.erc20.getContractAssetPath!);
          contract = ContractABI.fromJson(StringUtils.toJson<List>(contractJson)
              .map((e) => Map<String, dynamic>.from(e))
              .toList());
        }
      }
    }
    final method = MethodUtils.nullOnException(() {
      final method = contract?.findFunctionFromSelector(selector);
      final decodeInput = method?.decodeInput(data);
      if (decodeInput != null) {
        return SolidityNameAndInputValues(
            selector: selector, inputs: decodeInput, name: method!.name);
      }
      return null;
    });
    return method ??
        SolidityUnknownMethodInfo(selector: selector, dataHex: dataHex);
  }

  Future<SolidityToken?> _getAccountERC20Token(
      SolidityAddress account, SolidityAddress contractAddress) async {
    final token = await solidityClient.getErc20Details(contractAddress);
    if (token == null) return null;
    final balance = await solidityClient.provider
        .request(RPCERC20TokenBalance(contractAddress.toHex(), account));
    if (contractAddress is TronAddress) {
      return TronTRC20Token.create(
          balance: balance, token: token, contractAddress: contractAddress);
    }
    return ETHERC20Token.create(
        balance: balance,
        token: token,
        contractAddress: contractAddress as ETHAddress);
  }

  Future<(ContractABI, SolidityContractInterface)?> _detectContractAbi({
    required SolidityAddress contractAddress,
    required SolidityAddress from,
  }) async {
    SolidityContractInterface interface = SolidityContractInterface.none;
    for (final i in SolidityContractInterface.values) {
      try {
        final support = await solidityClient.provider.request(
            RPCDetectContactInterface(
                interface: i, contractAddress: contractAddress, from: from));
        if (support) {
          interface = i;
          break;
        }
      } on RPCError catch (_) {
        break;
      } catch (_) {}
    }
    final assetPath = interface.getContractAssetPath;
    if (assetPath == null) return null;
    final contractJson = await PlatformUtils.loadAssetText(assetPath);
    return (
      ContractABI.fromJson(StringUtils.toJson<List>(contractJson)
          .map((e) => Map<String, dynamic>.from(e))
          .toList()),
      interface
    );
  }

  Future<EthereumTransactionDataInfo>
      getTransactionContractInfo<NETWORKADDRESS extends SolidityAddress>(
          {required SolidityAddress account,
          required SolidityAddress contractAddress,
          required Chain chain,
          required List<int> data}) async {
    final dataHex = BytesUtils.toHexString(data, prefix: "0x");
    final selector = SolidityContractUtils.getSelector(data);
    if (selector == null) {
      return SolidityUnknownMethodInfo(selector: data, dataHex: dataHex);
    }
    final contract = await _detectContractAbi(
        contractAddress: contractAddress, from: account);
    return __getTransactionContractInfo<NETWORKADDRESS>(
        contract: contract?.$1,
        contractAddress: contractAddress,
        account: account,
        chain: chain,
        data: data,
        interface: contract?.$2,
        selector: selector,
        dataHex: dataHex);
  }
}
