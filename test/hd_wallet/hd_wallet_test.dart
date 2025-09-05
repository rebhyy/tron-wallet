import 'package:on_chain_wallet/wallet/provider/wallet_provider.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/models/authenticated.dart';
import 'package:on_chain_wallet/wallet/web3/core/request/params.dart';
import 'package:on_chain_wallet/wallet/web3/core/request/web_request.dart';

class TestWallet extends WalletCore {
  @override
  bool get useMemoryStorage => true;

  @override
  int get storageVersion => 0;

  @override
  Future<bool> onWeb3Request(
      Web3Request<dynamic, Web3WalletRequestParams, Web3RequestAuthentication>
          request) {
    throw UnimplementedError();
  }
}

void main() async {}
