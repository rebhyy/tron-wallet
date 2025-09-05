import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/core.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/methods/methods.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/permission/models/account.dart';

class Web3ADAGetAccountPub extends Web3ADARequestParam<List<int>> {
  final Web3ADAChainAccount accessAccount;

  Web3ADAGetAccountPub({required this.accessAccount});

  factory Web3ADAGetAccountPub.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
      cborBytes: bytes,
      object: object,
      hex: hex,
      tags: Web3MessageTypes.walletRequest.tag,
    );
    return Web3ADAGetAccountPub(
        accessAccount: Web3ADAChainAccount.deserialize(
            object: values.elementAs<CborTagValue>(1)));
  }

  @override
  Web3ADARequestMethods get method => Web3ADARequestMethods.getAccountPub;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([method.tag, accessAccount.toCbor()]),
        type.tag);
  }

  @override
  Future<Web3ADARequest<List<int>, Web3ADAGetAccountPub>> toRequest(
      {required Web3RequestInformation request,
      required Web3RequestAuthentication authenticated,
      required WEB3REQUESTNETWORKCONTROLLER<ICardanoAddress, ADAChain,
              Web3ADAChainAccount>
          chainController}) async {
    final chain = await super.findRequestChain(
        request: request,
        authenticated: authenticated,
        chainController: chainController);
    return Web3ADARequest<List<int>, Web3ADAGetAccountPub>(
        params: this,
        authenticated: authenticated,
        chain: chain.$1,
        info: request,
        accounts: chain.$2);
  }

  @override
  List<Web3ADAChainAccount> get requiredAccounts => [accessAccount];

  @override
  Object? toJsWalletResponse(List<int> response) {
    return response;
  }
}
