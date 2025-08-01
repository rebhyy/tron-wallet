import 'package:on_chain_wallet/crypto/models/networks.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/wallet/web3/web3.dart';

class Web3GlobalRequestConnectStateController
    extends Web3StateContoller<Web3GlobalRequest>
    with Web3GlobalRequestControllerState {
  final WalletProvider wallet;
  late Web3UpdatePermissionRequest _authenticated;
  Web3UpdatePermissionRequest get authenticated => _authenticated;
  @override
  final Web3GlobalRequest request;
  Web3GlobalRequestConnectStateController(
      {required this.request, required this.wallet});

  Future<bool> onUpdateApplication(List<NetworkType> networks) async {
    progressKey.response(text: "client_permission_have_been_updated".tr);
    request.completeResponse(networks);
    return true;
  }

  @override
  Future<void> initWeb3() async {
    final param = request.params.cast<Web3ConnectApplication>();
    final lockNetwork = param.chain;
    if (lockNetwork != null) {
      _authenticated = Web3UpdatePermissionRequest.network(
          authentication: request.authenticated, client: request.info.client);
    } else if (param.networks != null) {
      final networkIds = param.networks!;
      _authenticated = Web3UpdatePermissionRequest.chain(
          authentication: request.authenticated,
          client: request.info.client,
          lockedChains: wallet.wallet
              .getChains()
              .where((e) => networkIds.contains(e.network.value))
              .toList());
    }

    progressKey.idle();
  }
}
