import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/messages/messages.dart';
import 'package:on_chain_wallet/wallet/web3/core/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/aptos/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin_cash/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/params.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cosmos/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ethereum/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/permission.dart';
import 'package:on_chain_wallet/wallet/web3/networks/global/global.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/web3/networks/monero/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ripple/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/solana/solana.dart';
import 'package:on_chain_wallet/wallet/web3/networks/stellar/stellar.dart';
import 'package:on_chain_wallet/wallet/web3/networks/substrate/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/sui/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ton/ton.dart';
import 'package:on_chain_wallet/wallet/web3/networks/tron/tron.dart';
import 'web_request.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';

abstract class Web3WalletRequestParams<RESPONSE> extends Web3MessageCore {
  abstract final Web3RequestMethods method;
  const Web3WalletRequestParams();

  Object? toJsWalletResponse(RESPONSE response) {
    return response;
  }

  Object? toWalletConnectResponse(RESPONSE response) {
    return response;
  }

  Object? toPageResponse(RESPONSE response) {
    return response;
  }
}

abstract class Web3GlobalRequestParams<RESPONSE>
    extends Web3WalletRequestParams<RESPONSE> {
  @override
  Web3MessageTypes get type => Web3MessageTypes.walletGlobalRequest;
  const Web3GlobalRequestParams();
  @override
  abstract final Web3GlobalRequestMethods method;

  factory Web3GlobalRequestParams.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletGlobalRequest.tag);
    final network = Web3GlobalRequestMethods.fromId(values.elementAs(0));
    final Web3GlobalRequestParams param;
    switch (network) {
      case Web3GlobalRequestMethods.disconnect:
        param = Web3DisconnectApplication.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;

      case Web3GlobalRequestMethods.connect:
        param = Web3ConnectApplication.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case Web3GlobalRequestMethods.connectSilent:
        param = Web3SilentConnectApplication.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      default:
        throw Web3RequestExceptionConst.internalError;
    }
    if (param is! Web3GlobalRequestParams<RESPONSE>) {
      throw Web3RequestExceptionConst.internalError;
    }
    return param;
  }
}

typedef WEB3REQUESTPARAMSRESPONSE<RESPONSE> = Web3RequestParams<RESPONSE,
    dynamic, Chain, NETWORKCHAINACCOUNT<dynamic>, Web3ChainAccount>;
typedef WEB3REQUESTNETWORKCONTROLLER<WALLETACCOUNT extends ChainAccount,
        CHAIN extends Chain, CHAINACCOUNT extends Web3ChainAccount>
    = NetworkController<WALLETACCOUNT, CHAIN, CHAINACCOUNT, Web3InternalChain>;

abstract class Web3RequestParams<
        RESPONSE,
        NETWORKADDRESS,
        CHAIN extends Chain,
        WALLETACCOUNT extends ChainAccount,
        CHAINACCOUNT extends Web3ChainAccount>
    extends Web3WalletRequestParams<RESPONSE> {
  @override
  abstract final Web3NetworkRequestMethods method;
  List<CHAINACCOUNT> get requiredAccounts;

  Web3RequestParams();

  @override
  Web3MessageTypes get type => Web3MessageTypes.walletRequest;
  Future<Web3NetworkRequest> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<WALLETACCOUNT, CHAIN, CHAINACCOUNT>
          chainController});
  Future<(CHAIN, List<WALLETACCOUNT>)> findRequestChain(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<WALLETACCOUNT, CHAIN, CHAINACCOUNT>
          chainController}) async {
    final networkChains = chainController.networks;
    if (authenticated is Web3ApplicationAuthentication) {
      final accounts = await chainController.getWeb3AuthenticatedAccounts(
          authenticated, requiredAccounts);
      if (accounts == null) {
        throw Web3RequestExceptionConst.missingPermission;
      }
      return accounts;
    }
    if (requiredAccounts.isEmpty) {
      throw Web3RequestExceptionConst.missingPermission;
    }
    final accountChain = requiredAccounts.map((e) => e.id).toSet();
    if (accountChain.length != 1) {
      throw Web3RequestExceptionConst.invalidRequest;
    }
    final networkId = accountChain.elementAt(0);
    final chain = networkChains.firstWhere((e) => e.network.value == networkId,
        orElse: () => throw Web3RequestExceptionConst.networkDoesNotExists);
    final walletAccounts = requiredAccounts.map((e) {
      final acc = chain.getAddress(e.addressStr);
      if (acc == null) {
        throw Web3RequestExceptionConst.missingPermission;
      }
      return acc;
    }).toList();

    return (chain, walletAccounts.cast<WALLETACCOUNT>());
  }

  factory Web3RequestParams.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    final network =
        Web3NetworkRequestMethods.fromTag(values.elementAs(0)).network;
    final Web3RequestParams param;
    switch (network) {
      case NetworkType.ethereum:
        param = Web3EthereumRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.tron:
        param = Web3TronRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.solana:
        param = Web3SolanaRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.xrpl:
        param = Web3XRPRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.monero:
        param = Web3MoneroRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.cardano:
        param = Web3ADARequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.ton:
        param = Web3TonRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.stellar:
        param = Web3StellarRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.substrate:
        param = Web3SubstrateRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.aptos:
        param = Web3AptosRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.sui:
        param = Web3SuiRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.cosmos:
        param = Web3CosmosRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.bitcoinAndForked:
        param = Web3BitcoinRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      case NetworkType.bitcoinCash:
        param = Web3BitcoinCashRequestParam.deserialize(
            bytes: bytes, object: object, hex: hex);
        break;
      default:
        throw Web3RequestExceptionConst.internalError;
    }
    if (param is! Web3RequestParams<RESPONSE, NETWORKADDRESS, CHAIN,
        WALLETACCOUNT, CHAINACCOUNT>) {
      throw Web3RequestExceptionConst.internalError;
    }
    return param;
  }
}
