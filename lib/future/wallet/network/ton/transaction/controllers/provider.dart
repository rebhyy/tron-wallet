import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/app/live_listener/live.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:ton_dart/ton_dart.dart';

mixin TonTransactionApiController on DisposableMixin {
  TonClient get client;
  final Map<VersionedWalletContract, CachedObject<AccountStateResponse>>
      _cachedStates = {};

  Future<AccountStateResponse> getAccountState(
      VersionedWalletContract wallet) async {
    final obj = _cachedStates[wallet] ??= CachedObject<AccountStateResponse>(
        interval: const Duration(minutes: 1));
    return obj.get(
        onFetch: () async => await wallet.getState(rpc: client.provider));
  }

  Future<int> getAccountSeqno(VersionedWalletContract wallet) async {
    final state = await getAccountState(wallet);
    if (state.state.isFrozen) {
      throw AppException("ton_address_is_freez_desc");
    } else if (state.state.isActive) {
      final stateData = VersionedWalletUtils.readState(
          stateData: state.data, type: wallet.type, chain: wallet.chain);
      return stateData.seqno;
    } else {
      return 0;
    }
  }
}
