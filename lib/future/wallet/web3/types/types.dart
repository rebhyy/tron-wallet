import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:on_chain_wallet/crypto/models/networks.dart';
import 'package:on_chain_wallet/wallet/models/chain/chain/chain.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/models/authenticated.dart';

typedef ONWEB3PERMISSIONUPDATED = Future<bool> Function(
    List<NetworkType> networks);

class Web3UpdatePermissionRequest {
  final List<Chain> lockedChains;
  final List<NetworkType> lockedNetworks;
  final Web3APPAuthentication authentication;
  final Web3ClientInfo? client;
  late final Web3APPAuthentication cloneAutneticated = authentication.clone();
  bool haveRequiredPermissions() {
    final networks = requiredNetworkPermissions(authentication);
    final chains = requiredChainPermissions(authentication);
    return networks.isEmpty && chains.isEmpty;
  }

  List<NetworkType> requiredNetworkPermissions(
      Web3APPAuthentication authenticated) {
    if (!hasLockedNetwork) return [];
    List<NetworkType> requiredPermissions = [];
    for (final i in lockedNetworks) {
      final permission =
          authenticated.getChainFromNetworkType(i, allowDisable: true);
      if (permission.hasAccount) continue;
      requiredPermissions.add(i);
    }
    return requiredPermissions;
  }

  List<Chain> requiredChainPermissions(Web3APPAuthentication authenticated) {
    if (!hasLockedChain) return [];
    List<Chain> requiredPermissions = [];
    for (final i in lockedChains) {
      final permission = authenticated.getChainFromNetworkType(i.network.type,
          allowDisable: true);
      final accounts = permission.chainAccounts(i);
      if (accounts.isNotEmpty) continue;
      requiredPermissions.add(i);
    }
    return requiredPermissions;
  }

  Web3UpdatePermissionRequest._(
      {List<Chain> lockedChains = const [],
      List<NetworkType> lockedNetworks = const [],
      required this.authentication,
      this.client})
      : lockedChains = lockedChains.immutable,
        lockedNetworks = lockedNetworks.immutable;
  factory Web3UpdatePermissionRequest.chain(
      {List<Chain> lockedChains = const [],
      required Web3APPAuthentication authentication,
      Web3ClientInfo? client}) {
    return Web3UpdatePermissionRequest._(
        authentication: authentication,
        lockedChains: lockedChains,
        client: client,
        lockedNetworks: lockedChains
            .map((e) => e.network.type.isBitcoin
                ? NetworkType.bitcoinAndForked
                : e.network.type)
            .toSet()
            .toList());
  }
  factory Web3UpdatePermissionRequest(
      {required Web3APPAuthentication authentication, Web3ClientInfo? client}) {
    return Web3UpdatePermissionRequest._(
      authentication: authentication,
      client: client,
    );
  }
  factory Web3UpdatePermissionRequest.network(
      {List<NetworkType> networks = const [],
      required Web3APPAuthentication authentication,
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
