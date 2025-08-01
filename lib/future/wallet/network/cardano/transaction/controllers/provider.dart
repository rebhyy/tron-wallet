import 'package:on_chain/ada/src/provider/blockfrost/models/models/epoch_parameters.dart';
import 'package:on_chain_wallet/app/live_listener/live.dart';
import 'package:on_chain_wallet/future/wallet/network/cardano/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

mixin ADATransactionApiController on DisposableMixin {
  CardanoClient get client;
  WalletCardanoNetwork get network;
  late final CachedObject<ADAEpochParametersResponse>
      _latestEpochProtocolParameters = CachedObject<ADAEpochParametersResponse>(
          interval: Duration(seconds: network.coinParam.averageBlockTime));

  Future<List<CardanoAccountUtxo>> getAccountUtxos(
      ADAChain account, ICardanoAddress address) async {
    // BlockFrostProviderUtils.;
    final utxos = await account.getAddressUtxos(address);
    return utxos
        .map((e) =>
            CardanoAccountUtxo(utxo: e, network: network, address: address))
        .toList();
  }

  Future<ADAEpochParametersResponse> latestEpochProtocolParameters() async {
    return await _latestEpochProtocolParameters.get(
        onFetch: () async => await client.latestEpochProtocolParameters());
  }
}
