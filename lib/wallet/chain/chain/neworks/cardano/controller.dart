part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

base mixin ADAChainController on Chain<
    CardanoAPIProvider,
    CardanoNetworkParams,
    ADAAddress,
    TokenCore,
    NFTCore,
    ICardanoAddress,
    WalletCardanoNetwork,
    ADAClient,
    ADANetworkConfig,
    ADAWalletTransaction,
    CardanoContact,
    BaseCardanoNewAddressParams> {
  final Map<ICardanoAddress, CachedObject<List<ADAAccountUTXOResponse>>>
      _utxos = {};

  Future<List<ADAAddressUtxo>> getAddressUtxos(ICardanoAddress address) async {
    _isAccountAddress(address);
    await onClient(
        onConnect: (client) async {
          _utxos[address] ??=
              CachedObject(interval: const Duration(minutes: 1));
          final cachedUtxos = _utxos[address]!;
          final utxos = await cachedUtxos.get(
              onFetch: () async => await client.getAccountUtxos(
                  address: address.networkAddress));
          final addressUtxos = await address._getUtxos();

          Set<ADAAddressUtxo> existsUtxos = addressUtxos.utxos.clone();
          existsUtxos = existsUtxos
              .where((e) => utxos.any((u) => u.toInput == e.input))
              .toSet();
          address._updateUtxos(existsUtxos);
          final existInputs = existsUtxos.map((e) => e.input);
          final newUtxos =
              utxos.where((e) => !existInputs.contains(e.toInput)).toList();
          if (newUtxos.isEmpty) {
            return utxos;
          }
          final txInputs = newUtxos.map((e) => e.toInput).toList();
          final txes = await client.getTxesFromInputs(txInputs);
          for (final i in newUtxos) {
            final tx = txes.firstWhereOrNull((e) => e.txInput == i.toInput);
            if (tx == null) continue;
            existsUtxos.add(ADAAddressUtxo.fromUtxo(i, tx.output));
          }
          address._updateUtxos(existsUtxos);
          final txIds = txInputs.map((e) => e.txIdHex).toSet();
          for (final i in txIds) {
            final tx = txes.firstWhereOrNull(
                (e) => e.txInput.txIdHex == e.txInput.txIdHex);
            if (tx == null) continue;
            final addressUtxos =
                newUtxos.where((e) => e.toInput.txIdHex == i).toList();
            if (addressUtxos.isEmpty) continue;
            final walletTx = ADAWalletTransaction(
                txId: i,
                time: tx.blockTime,
                outputs: [],
                type: WalletTransactionType.receive,
                status: WalletTransactionStatus.block,
                totalOutput: WalletTransactionIntegerAmount(
                    amount: addressUtxos.sumOflovelace, network: network),
                network: network);
            saveTransaction(address: address, transaction: walletTx);
          }
          return utxos;
        },
        onError: (err) => throw err);
    final utxos = await address._getUtxos();
    return utxos.utxos.toList();
  }

  Future<List<TransactionUnspentOutput>> _getTransactionUnspentOutputs(
      ICardanoAddress address) async {
    final utxos = await address._getUtxos();
    return utxos.transactionUnspentOutputs;
  }

  Future<List<TransactionUnspentOutput>> _getLatestTransactionUnspentOutputs(
      ICardanoAddress address) async {
    final utxos = await getAddressUtxos(address);
    return utxos.map((e) => e.transactionUnspentOutput).toList();
  }

  @override
  Future<void> _updateAddressBalanceInternal(ICardanoAddress address,
      {bool tokens = true}) async {
    if (address.isRewardAddress) return;
    await getAddressUtxos(address).catchError((e) {
      return <ADAAddressUtxo>[];
    });
  }
}
