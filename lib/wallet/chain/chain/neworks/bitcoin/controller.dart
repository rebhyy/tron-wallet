part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

base mixin BitcoinChainController on Chain<
    BaseBitcoinAPIProvider,
    BitcoinParams,
    BitcoinBaseAddress,
    TokenCore,
    NFTCore,
    IBitcoinAddress,
    WalletBitcoinNetwork,
    BitcoinClient,
    BitcoinNetworkConfig,
    BitcoinWalletTransaction,
    BitcoinContact,
    BaseBitcoinNewAddressParams> {
  final Map<IBitcoinAddress, CachedObject<List<BitcoinUTXO>>> _utxos = {};

  Future<List<UtxoWithAddress>> getAccountUtxos(IBitcoinAddress address) async {
    _isAccountAddress(address);
    await onClient(
        onConnect: (client) async {
          _utxos[address] ??=
              CachedObject(interval: const Duration(minutes: 1));
          final cachedUtxos = _utxos[address]!;
          final utxos = await cachedUtxos.get(onFetch: () async {
            final utxos = await client.readUtxos(
                address.toUtxoRequest, network.coinParam.isBCH);
            return utxos.map((e) {
              bool confirmed = (e.utxo.blockHeight ?? 0) > 0;
              return BitcoinUTXO(
                  index: e.utxo.vout,
                  value: e.utxo.value,
                  token: e.utxo.token,
                  txId: e.utxo.txHash,
                  status: confirmed
                      ? BitcoinUTXOStatus.comfirmed
                      : BitcoinUTXOStatus.mempool);
            }).toList();
          });

          Set<BitcoinUTXO> existsUtxos = (await address._getUtxos()).utxos;
          existsUtxos = existsUtxos.where((e) => utxos.contains(e)).toSet();
          final newUtxos =
              utxos.where((e) => !existsUtxos.contains(e)).toList();
          address._updateUtxos(utxos);
          if (newUtxos.isEmpty) {
            return utxos;
          }
          final txInfos = await client.getTrasactionsBlockInfo(newUtxos
              .where((e) => e.status.confirmed)
              .map((e) => e.txId)
              .toList());
          final List<String> newTxes =
              newUtxos.map((e) => e.txId).toSet().toList();
          final scriptHash = address.networkAddress.pubKeyHash();

          for (final i in newTxes) {
            final tx = txInfos.firstWhereOrNull((e) => e.txId == i);
            final addressUtxos = newUtxos.where((e) => e.txId == i).toList();
            if (addressUtxos.isEmpty) continue;
            bool confirmed = tx?.confirmed ?? addressUtxos[0].status.confirmed;
            final walletTx = BitcoinWalletTransaction(
                txId: i,
                time: tx?.blockTime,
                outputs: [],
                type: WalletTransactionType.receive,
                scriptHash: scriptHash,
                status: confirmed
                    ? WalletTransactionStatus.block
                    : WalletTransactionStatus.pending,
                totalOutput: WalletTransactionIntegerAmount(
                    amount:
                        addressUtxos.fold(BigInt.zero, (p, c) => p + c.value),
                    network: network),
                network: network);
            saveTransaction(address: address, transaction: walletTx);
          }

          return utxos;
        },
        onError: (err) => throw err);
    final utxos = (await address._getUtxos()).utxos;
    return utxos
        .map((e) => UtxoWithAddress(
            utxo: BitcoinUtxo(
                txHash: e.txId,
                value: e.value,
                vout: e.index,
                token: e.token,
                scriptType: address.networkAddress.type),
            ownerDetails: address.toUtxoRequest))
        .toList();
  }
}
