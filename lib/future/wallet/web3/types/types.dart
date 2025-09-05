import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/models/authenticated.dart';

typedef ONWEB3PERMISSIONUPDATED = Future<bool> Function(
    Web3PermissionUpdateResponse);

class Web3PermissionUpdateResponse {
  final Web3DappInfo appInfo;
  final Web3ApplicationAuthentication authentication;
  final List<NetworkType> chains;
  final bool hasRequiredPermission;
  const Web3PermissionUpdateResponse(
      {required this.authentication,
      required this.hasRequiredPermission,
      required this.appInfo,
      required this.chains});
}

class Web3UpdatePermissionRequest {
  final List<Chain> lockedChains;
  final List<NetworkType> lockedNetworks;
  final Web3ApplicationAuthentication authentication;
  final Web3ClientInfo? client;
  late final Web3ApplicationAuthentication cloneAutneticated =
      authentication.clone();

  Web3UpdatePermissionRequest._(
      {List<Chain> lockedChains = const [],
      List<NetworkType> lockedNetworks = const [],
      required this.authentication,
      this.client})
      : lockedChains = lockedChains.immutable,
        lockedNetworks = lockedNetworks.immutable;
  factory Web3UpdatePermissionRequest.chain(
      {List<Chain> lockedChains = const [],
      required Web3ApplicationAuthentication authentication,
      Web3ClientInfo? client}) {
    return Web3UpdatePermissionRequest._(
        authentication: authentication,
        lockedChains: lockedChains,
        client: client,
        lockedNetworks:
            lockedChains.map((e) => e.network.type).toSet().toList());
  }
  factory Web3UpdatePermissionRequest(
      {required Web3ApplicationAuthentication authentication,
      Web3ClientInfo? client}) {
    return Web3UpdatePermissionRequest._(
      authentication: authentication,
      client: client,
    );
  }
  factory Web3UpdatePermissionRequest.network(
      {List<NetworkType> networks = const [],
      required Web3ApplicationAuthentication authentication,
      Web3ClientInfo? client}) {
    return Web3UpdatePermissionRequest._(
        authentication: authentication,
        client: client,
        lockedNetworks: networks.toSet().toList());
  }
  bool get hasLockedNetwork => lockedNetworks.isNotEmpty;
  bool get hasLockedChain => lockedChains.isNotEmpty;
  bool networkDisabled(NetworkType network) {
    if (hasLockedNetwork) return !lockedNetworks.contains(network);
    return false;
  }

  bool chainDisabled(Chain network) {
    if (hasLockedChain) return !lockedChains.contains(network);
    return false;
  }
}
