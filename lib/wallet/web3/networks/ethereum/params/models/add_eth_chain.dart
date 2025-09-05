import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ethereum/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ethereum/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/ethereum/permission/models/account.dart';

class Web3EthereumAddNewChain extends Web3EthereumRequestParam<String> {
  final BigInt newChainId;
  final String chainName;
  final String name;
  final String symbol;
  final List<String> rpcUrls;
  final List<String>? blockExplorerUrls;
  final List<String>? iconUrls;
  final int decimals;

  Web3EthereumAddNewChain._(
      {required this.newChainId,
      required this.chainName,
      required this.name,
      required this.symbol,
      required this.decimals,
      required List<String> rpcUrls,
      required List<String>? blockExplorerUrls,
      required List<String>? iconUrls})
      : rpcUrls = rpcUrls.imutable,
        blockExplorerUrls = blockExplorerUrls?.imutableAndNullOnEmpty,
        iconUrls = iconUrls?.imutableAndNullOnEmpty;
  factory Web3EthereumAddNewChain(
      {required BigInt newChainId,
      required String chainName,
      required String name,
      required String symbol,
      required int decimals,
      required List<String> rpcUrls,
      required List<String>? blockExplorerUrls,
      required List<String>? iconUrls}) {
    return Web3EthereumAddNewChain._(
        newChainId: newChainId,
        chainName: chainName,
        name: name,
        symbol: symbol,
        decimals: decimals,
        rpcUrls: rpcUrls,
        blockExplorerUrls:
            (blockExplorerUrls?.isEmpty ?? true) ? null : blockExplorerUrls,
        iconUrls: (iconUrls?.isEmpty ?? true) ? null : iconUrls);
  }

  factory Web3EthereumAddNewChain.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: Web3MessageTypes.walletRequest.tag);
    return Web3EthereumAddNewChain(
        newChainId: values.elementAs(1),
        chainName: values.elementAs(2),
        name: values.elementAs(3),
        symbol: values.elementAs(4),
        rpcUrls: values.elementAs<CborListValue>(5).castValue<String>(),
        blockExplorerUrls:
            values.elementAs<CborListValue?>(6)?.castValue<String>(),
        iconUrls: values.elementAs<CborListValue?>(7)?.castValue<String>(),
        decimals: values.elementAs(8));
  }

  @override
  Web3EthereumRequestMethods get method =>
      Web3EthereumRequestMethods.addEthereumChain;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          method.tag,
          newChainId,
          chainName,
          name,
          symbol,
          CborSerializable.fromDynamic(rpcUrls),
          blockExplorerUrls == null
              ? const CborNullValue()
              : CborSerializable.fromDynamic(blockExplorerUrls!),
          iconUrls == null
              ? const CborNullValue()
              : CborSerializable.fromDynamic(blockExplorerUrls!),
          decimals
        ]),
        type.tag);
  }

  @override
  Future<Web3EthereumRequest<String, Web3EthereumAddNewChain>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<IEthAddress, EthereumChain,
              Web3EthereumChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3EthereumRequest<String, Web3EthereumAddNewChain>(
      params: this,
      authenticated: authenticated,
      chain: chain.$1,
      info: request,
      accounts: chain.$2,
    );
  }
}
